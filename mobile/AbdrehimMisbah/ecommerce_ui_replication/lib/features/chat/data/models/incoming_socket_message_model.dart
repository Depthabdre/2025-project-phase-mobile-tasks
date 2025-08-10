import 'package:equatable/equatable.dart';

import '../../domain/entities/incoming_socket_message.dart';

class IncomingSocketMessageModel extends Equatable {
  final String chatId;
  final String message;
  final String type;

  const IncomingSocketMessageModel({
    required this.chatId,
    required this.message,
    required this.type,
  });

  factory IncomingSocketMessageModel.fromJson(Map<String, dynamic> json) {
    return IncomingSocketMessageModel(
      chatId: json['chatId'] as String,
      message: json['message'] as String,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'chatId': chatId, 'message': message, type: 'type'};
  }

  IncomingSocketMessage toEntity() {
    return IncomingSocketMessage(chatId: chatId, message: message, type: type);
  }

  @override
  List<Object> get props => [chatId, message, type];
}
