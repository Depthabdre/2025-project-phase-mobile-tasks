import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/incoming_socket_message.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_all_chat.dart';

import '../../domain/usecases/get_chat_message.dart';

import '../../domain/usecases/initiate_chat.dart';

import '../../domain/usecases/listen_incoming_message.dart';
import '../../domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllChats getAllChats;
  final GetChatMessages getChatMessages;
  final InitiateChatUseCase initiateChat;
  final SendMessage sendMessage;
  final ListenForIncomingMessages listenForIncomingMessages;

  StreamSubscription? _messageSubscription;
  List<Message> _currentMessages = [];

  ChatBloc({
    required this.getAllChats,
    required this.getChatMessages,
    required this.initiateChat,
    required this.sendMessage,
    required this.listenForIncomingMessages,
  }) : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<StartListeningMessagesEvent>(_onStartListening);
    on<IncomingMessageEvent>(_onIncomingMessage);
    on<InitiateChatEvent>(_onInitiateChat);
  }

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await getAllChats();
    result.fold(
      (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
      (chats) => emit(ChatsLoaded(chats: chats)),
    );
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await getChatMessages(event.chatId);
    result.fold(
      (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
      (messages) {
        _currentMessages = messages;
        emit(MessagesLoaded(messages: messages));
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await sendMessage(
      chatId: event.chatId,
      content: event.content,
      type: event.type,
    );
    result.fold(
      (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
      (_) {
        // Sending message will trigger message:delivered from socket
      },
    );
  }

  void _onStartListening(
    StartListeningMessagesEvent event,
    Emitter<ChatState> emit,
  ) {
    _messageSubscription?.cancel();
    _messageSubscription = listenForIncomingMessages().listen((
      eitherFailureOrMessage,
    ) {
      eitherFailureOrMessage.fold(
        (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
        (message) => add(IncomingMessageEvent(message: message)),
      );
    });
  }

  void _onIncomingMessage(IncomingMessageEvent event, Emitter<ChatState> emit) {
    final newMsg = Message(
      id: 'temp key', // temp ID
      sender: const User(
        id: 'otherUserId',
        name: 'Unknown',
        email: 'temp@gmail.com',
      ), // you can map this properly
      chatId: event.message.chatID,
      content: event.message.message,
      type: 'text',
    );

    _currentMessages.add(newMsg);
    emit(MessagesLoaded(messages: List.from(_currentMessages)));
  }

  Future<void> _onInitiateChat(
    InitiateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await initiateChat(event.userId);
    result.fold(
      (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
      (chat) => emit(ChatInitiated(chat: chat)),
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure _:
      return 'Server Failure';
    case CacheFailure _:
      return 'Cache Failure';
    case NetworkFailure _:
      return 'No Internet Connection';
    default:
      return 'Unexpected error';
  }
}
