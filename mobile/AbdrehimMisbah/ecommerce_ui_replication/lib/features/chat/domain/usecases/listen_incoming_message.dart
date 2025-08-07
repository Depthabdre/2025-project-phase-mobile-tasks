import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class ListenForIncomingMessages {
  final ChatRepository repository;

  ListenForIncomingMessages(this.repository);

  Stream<Message> call() {
    return repository.messageStream();
  }
}
