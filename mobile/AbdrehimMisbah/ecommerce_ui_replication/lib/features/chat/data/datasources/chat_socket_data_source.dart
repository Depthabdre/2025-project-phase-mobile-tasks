import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../core/error/failure.dart';
import '../../domain/entities/message.dart';
import '../models/message_model.dart';

abstract class ChatSocketDataSource {
  void connect();
  void disconnect();

  void sendMessage({
    required String chatId,
    required String content,
    required String type,
  });

  Stream<Either<Failure, Message>> get messageStream;
}

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  final String baseUrl;
  final SharedPreferences sharedPreferences;
  late IO.Socket _socket;

  final _messageController =
      StreamController<Either<Failure, MessageModel>>.broadcast();

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

    _socket.onConnect((_) => print('Socket connected'));
    _socket.onDisconnect((_) => print('Socket disconnected'));

    _socket.on('message:received', (data) {
      try {
        final message = MessageModel.fromJson(data);
        _messageController.add(Right(message)); // Wrap in Right on success
      } catch (e) {
        _messageController.add(Left(ServerFailure())); // Wrap error in Left
      }
    });

    _socket.on('message:delivered', (data) {
      print('Message delivered ack received: $data');
    });
  }

  @override
  void disconnect() {
    _socket.dispose();
    _messageController.close();
  }

  @override
  void sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) {
    final payload = {'chatId': chatId, 'content': content, 'type': type};
    _socket.emit('message:send', payload);
  }

  @override
  Stream<Either<Failure, Message>> get messageStream => _messageController
      .stream
      .map((eitherModel) => eitherModel.map((model) => model.toEntity()));
}
