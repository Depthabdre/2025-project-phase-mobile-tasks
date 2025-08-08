import 'package:equatable/equatable.dart';

class IncomingSocketMessage extends Equatable {
  final String chatID;
  final String message;

  const IncomingSocketMessage({required this.chatID, required this.message});

  @override
  List<Object> get props => [chatID, message];
}
