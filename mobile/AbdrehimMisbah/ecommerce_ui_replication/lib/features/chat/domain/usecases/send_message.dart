import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, void>> call({
    required String chatId,
    required String content,
    required String type,
  }) async {
    return await repository.sendMessage(
      chatId: chatId,
      content: content,
      type: type,
    );
  }
}
