import 'package:equatable/equatable.dart';

class IncomingSocketMessage extends Equatable {
  final String chatId;
  final String message;
  final String type;

  const IncomingSocketMessage({
    required this.chatId,
    required this.message,
    required this.type,
  });

  @override
  List<Object> get props => [chatId, message, type];
}
