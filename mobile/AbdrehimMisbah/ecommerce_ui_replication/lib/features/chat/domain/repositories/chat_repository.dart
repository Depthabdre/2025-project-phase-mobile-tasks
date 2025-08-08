import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  /// Fetch all active chats for the current user.
  Future<Either<Failure, List<Chat>>> getAllChats();

  /// Fetch all messages inside a chat by its ID.
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);

  // To Initate the chat
  Future<Either<Failure, Chat>> initiateChat(String userId);

  /// Send a new message via socket.
  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });

  /// Listen for real-time incoming messages from the socket.
  Stream<Either<Failure, Message>> get messageStream;
}
