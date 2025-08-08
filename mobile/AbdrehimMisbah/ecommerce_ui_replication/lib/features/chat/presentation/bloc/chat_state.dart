part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;
  const ChatsLoaded({required this.chats});
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  const MessagesLoaded({required this.messages});
}

class ChatInitiated extends ChatState {
  final Chat chat;
  const ChatInitiated({required this.chat});
}

class ChatError extends ChatState {
  final String message;
  const ChatError({required this.message});
}
