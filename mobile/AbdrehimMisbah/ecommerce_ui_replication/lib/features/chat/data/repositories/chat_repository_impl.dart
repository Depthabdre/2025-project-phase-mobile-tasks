import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/chat_socket_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatSocketDataSource socketService;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketService,
  });

  @override
  Future<Either<Failure, List<Chat>>> getAllChats() async {
    try {
      final chatModels = await remoteDataSource.getAllChats();
      final chats = chatModels.map((model) => model.toEntity()).toList();
      return Right(chats);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    try {
      final messageModels = await remoteDataSource.getChatMessages(chatId);
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // RepositoryImpl
  @override
  Future<Either<Failure, Chat>> initiateChat(String userId) async {
    try {
      final chatModel = await remoteDataSource.initiateChat(userId);
      return Right(chatModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String content,
    required String type,
  }) async {
    try {
      socketService.sendMessage(chatId: chatId, content: content, type: type);
      return const Right(null); // success with no data
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Either<Failure, Message>> get messageStream =>
      socketService.messageStream;
}
