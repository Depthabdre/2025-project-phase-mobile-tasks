import 'package:equatable/equatable.dart';

import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Equatable {
  final String id;
  final UserModel sender;
  final String chatId;
  final String content;
  final String type;

  const MessageModel({
    required this.id,
    required this.sender,
    required this.chatId,
    required this.content,
    required this.type,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: json['chatId'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'chatId': chatId,
      'content': content,
      'type': type,
    };
  }

  Message toEntity() {
    return Message(
      id: id,
      sender: sender.toEntity(),
      chatId: chatId,
      content: content,
      type: type,
    );
  }

  @override
  List<Object?> get props => [id, sender, chatId, content, type];
}
