import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../core/error/failure.dart';
import '../../domain/entities/incoming_socket_message.dart';
import '../../domain/entities/message.dart';
import '../models/incoming_socket_message_model.dart';
import '../models/message_model.dart';

abstract class ChatSocketDataSource {
  void connect();
  void disconnect();

  void sendMessage({required String chatId, required String content});

  Stream<Either<Failure, IncomingSocketMessage>> get messageStream;
}

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  final String baseUrl;
  final SharedPreferences sharedPreferences;
  late IO.Socket _socket;

  // We keep this open for the lifetime of the data source
  final _messageController =
      StreamController<Either<Failure, IncomingSocketMessageModel>>.broadcast();

  ChatSocketDataSourceImpl({
    required this.baseUrl,
    required this.sharedPreferences,
  });

  @override
  void connect() {
    final authToken = sharedPreferences.getString('CACHED_AUTH_TOKEN') ?? '';

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableAutoConnect()
          .setQuery({'token': authToken})
          .build(),
    );

    _socket.onConnect((_) => print('✅ Socket connected'));
    _socket.onDisconnect((_) => print('❌ Socket disconnected'));
    _socket.onReconnect((_) => print('🔄 Socket reconnected'));
    _socket.onReconnectAttempt((_) => print('⏳ Attempting to reconnect...'));

    // Common message handler
    void handleMessageEvent(dynamic data) {
      try {
        final message = IncomingSocketMessageModel.fromJson(data);
        _messageController.add(Right(message));
      } catch (e) {
        print('⚠️ Parsing error: $e');
        print('Raw data: $data');
        _messageController.add(Left(ServerFailure()));
      }
    }

    // Listen for both events
    _socket.on('message:received', handleMessageEvent);
    _socket.on('message:delivered', handleMessageEvent);
  }

  @override
  void disconnect() {
    _socket.disconnect();
    _socket.close();
    print('🔌 Socket manually disconnected');
    // Note: we are NOT closing _messageController here to allow reconnection
  }

  @override
  void sendMessage({required String chatId, required String content}) {
    final msgModel = IncomingSocketMessageModel(
      chatID: chatId,
      message: content,
    );
    final payload = msgModel.toJson();

    _socket.emit('message:send', payload);

    print('📤 Sent message: $payload');
  }

  @override
  Stream<Either<Failure, IncomingSocketMessage>> get messageStream =>
      _messageController.stream.map(
        (eitherModel) => eitherModel.map((model) => model.toEntity()),
      );
}
