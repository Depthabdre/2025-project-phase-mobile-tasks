import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  /// Fetch all active chats for the current user.
  Future<Either<Failure, List<Chat>>> getAllChats();

  /// Fetch all messages inside a chat by its ID.
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);

  /// Send a new message via socket.
  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String type,
  });

  /// Listen for real-time incoming messages from the socket.
  Stream<Message> messageStream();
}
