import 'package:equatable/equatable.dart';

import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/chat.dart';

class ChatModel extends Equatable {
  final String id;
  final UserModel user1;
  final UserModel user2;

  const ChatModel({required this.id, required this.user1, required this.user2});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      user1: UserModel.fromJson(json['user1'] as Map<String, dynamic>),
      user2: UserModel.fromJson(json['user2'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'user1': user1.toJson(), 'user2': user2.toJson()};
  }

  Chat toEntity() {
    return Chat(id: id, user1: user1.toEntity(), user2: user2.toEntity());
  }

  @override
  List<Object?> get props => [id, user1, user2];
}
