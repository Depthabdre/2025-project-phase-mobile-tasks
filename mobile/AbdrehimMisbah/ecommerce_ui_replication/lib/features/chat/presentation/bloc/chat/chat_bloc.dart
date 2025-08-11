import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/entities/chat.dart';
import '../../../domain/entities/incoming_socket_message.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/usecases/get_all_chat.dart';

import '../../../domain/usecases/get_chat_message.dart';

import '../../../domain/usecases/initiate_chat.dart';

import '../../../domain/usecases/listen_for_delivered_messages.dart';
import '../../../domain/usecases/listen_incoming_message.dart';
import '../../../domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllChats getAllChats;
  final GetChatMessages getChatMessages;
  final InitiateChatUseCase initiateChat;
  final SendMessage sendMessage;
  final ListenForIncomingMessages listenForIncomingMessages;
  final ListenForDeliveredMessages listenForDeliveredMessages;
  final Set<String> _deliveredMessageKeys = {};
  bool _initialMessagesLoaded = false;

  StreamSubscription? _messageSubscription;
  List<Message> _currentMessages = [];

  ChatBloc({
    required this.getAllChats,
    required this.getChatMessages,
    required this.initiateChat,
    required this.sendMessage,
    required this.listenForIncomingMessages,
    required this.listenForDeliveredMessages,
  }) : super(ChatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<StartListeningMessagesEvent>(_onStartListening);
    on<IncomingMessageEvent>(_onIncomingMessage);
    on<InitiateChatEvent>(_onInitiateChat);
    on<MessageDeliveredEvent>(_onMessageDelivered);
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
        // Mark all API-loaded messages as delivered
        for (var msg in messages) {
          _deliveredMessageKeys.add('${msg.chatId}_${msg.content}');
        }

        _initialMessagesLoaded = true;
        emit(
          MessagesLoaded(
            messages: List.from(_currentMessages),
            deliveredKeys: Set.from(_deliveredMessageKeys),
          ),
        );
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    IncomingSocketMessage outgoingMessage = IncomingSocketMessage(
      chatId: event.chatId,
      content: event.content,
      type: 'text',
    );

    final result = await sendMessage(outgoingMessage: outgoingMessage);
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

    // Listen for new messages
    _messageSubscription = listenForIncomingMessages().listen((either) {
      either.fold(
        (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
        (incoming) => add(IncomingMessageEvent(message: incoming)),
      );
    });

    // Listen for delivery confirmations
    listenForDeliveredMessages().listen((either) {
      either.fold(
        (failure) => emit(ChatError(message: _mapFailureToMessage(failure))),
        (incoming) => add(MessageDeliveredEvent(message: incoming)),
      );
    });
  }

  void _onIncomingMessage(IncomingMessageEvent event, Emitter<ChatState> emit) {
    if (_currentMessages.any((m) => m.id == event.message.id)) {
      return; // already exists, avoid duplicate & rebuild
    }

    _currentMessages = [..._currentMessages, event.message];
    emit(
      MessagesLoaded(
        messages: List.from(_currentMessages),
        deliveredKeys: Set.from(_deliveredMessageKeys),
      ),
    );
  }

  void _onMessageDelivered(
    MessageDeliveredEvent event,
    Emitter<ChatState> emit,
  ) {
    if (_initialMessagesLoaded) {
      final key = '${event.message.chatId}_${event.message.content}';

      if (!_deliveredMessageKeys.contains(key)) {
        _deliveredMessageKeys.add(key);
        _currentMessages = List.from(_currentMessages)..add(event.message);
        emit(
          MessagesLoaded(
            messages: List.from(_currentMessages),
            deliveredKeys: Set.from(_deliveredMessageKeys),
          ),
        );
      }
    }
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

  Set<String> get deliveredMessageKeys => _deliveredMessageKeys;
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
