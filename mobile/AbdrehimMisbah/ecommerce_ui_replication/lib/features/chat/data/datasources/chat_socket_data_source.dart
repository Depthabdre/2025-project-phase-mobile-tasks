import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/error/failure.dart';
import '../../domain/entities/incoming_socket_message.dart';
import '../models/incoming_socket_message_model.dart';

abstract class ChatSocketDataSource {
  void connect();
  void disconnect();
  void sendMessage({required IncomingSocketMessage outgoingMessage});

  /// New message from another user
  Stream<Either<Failure, IncomingSocketMessage>> get messageReceivedStream;

  /// Confirmation that one of our sent messages was delivered
  Stream<Either<Failure, IncomingSocketMessage>> get messageDeliveredStream;
}

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  final String baseUrl;
  final SharedPreferences sharedPreferences;
  late IO.Socket _socket;

  final _receivedController =
      StreamController<Either<Failure, IncomingSocketMessageModel>>.broadcast();

  final _deliveredController =
      StreamController<Either<Failure, IncomingSocketMessageModel>>.broadcast();

  bool _isConnected = false;

  ChatSocketDataSourceImpl({
    required this.baseUrl,
    required this.sharedPreferences,
  });

  @override
  void connect() {
    if (_isConnected) {
      print('⚠️ Socket already connected');
      return;
    }

    final authToken = sharedPreferences.getString('CACHED_AUTH_TOKEN') ?? '';

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $authToken'})
          .build(),
    );

    _socket.onConnect((_) {
      _isConnected = true;
      print('✅ Socket connected to $baseUrl');
    });

    _socket.onDisconnect((_) {
      _isConnected = false;
      print('❌ Socket disconnected');
    });

    _socket.onReconnect((_) => print('🔄 Socket reconnected'));
    _socket.onReconnectAttempt((_) => print('⏳ Attempting to reconnect...'));

    // Listen for incoming messages
    _socket.on('message:received', (data) {
      try {
        final message = IncomingSocketMessageModel.fromJson(data);
        _receivedController.add(Right(message));
      } catch (e) {
        print('⚠️ Error parsing received message: $e');
        _receivedController.add(Left(ServerFailure()));
      }
    });

    // Listen for delivery confirmations
    _socket.on('message:delivered', (data) {
      try {
        final message = IncomingSocketMessageModel.fromJson(data);
        _deliveredController.add(Right(message));
      } catch (e) {
        print('⚠️ Error parsing delivered message: $e');
        _deliveredController.add(Left(ServerFailure()));
      }
    });
  }

  @override
  void disconnect() {
    if (!_isConnected) {
      print('⚠️ Socket is not connected');
      return;
    }

    _socket.disconnect();
    _socket.close();
    _isConnected = false;
    print('🔌 Socket manually disconnected');
  }

  @override
  void sendMessage({required IncomingSocketMessage outgoingMessage}) {
    if (!_isConnected) {
      print('❌ Cannot send message — socket not connected');
      return;
    }

    final msgModel = IncomingSocketMessageModel(
      chatID: outgoingMessage.chatID,
      message: outgoingMessage.message,
    );

    final payload = msgModel.toJson();
    _socket.emit('message:send', payload);
    print('📤 Sent message: $payload');
  }

  @override
  Stream<Either<Failure, IncomingSocketMessage>> get messageReceivedStream =>
      _receivedController.stream.map(
        (eitherModel) => eitherModel.map((model) => model.toEntity()),
      );

  @override
  Stream<Either<Failure, IncomingSocketMessage>> get messageDeliveredStream =>
      _deliveredController.stream.map(
        (eitherModel) => eitherModel.map((model) => model.toEntity()),
      );
}
