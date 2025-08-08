import 'package:equatable/equatable.dart';

import '../../domain/entities/incoming_socket_message.dart';

class IncomingSocketMessageModel extends Equatable {
  final String chatID;
  final String message;

  const IncomingSocketMessageModel({
    required this.chatID,
    required this.message,
  });

  factory IncomingSocketMessageModel.fromJson(Map<String, dynamic> json) {
    return IncomingSocketMessageModel(
      chatID: json['chatID'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'chatID': chatID, 'message': message};
  }

  IncomingSocketMessage toEntity() {
    return IncomingSocketMessage(chatID: chatID, message: message);
  }

  @override
  List<Object> get props => [chatID, message];
}
