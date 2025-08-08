import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/incoming_socket_message.dart';
import '../repositories/chat_repository.dart';

class ListenForIncomingMessages {
  final ChatRepository repository;

  ListenForIncomingMessages(this.repository);

  Stream<Either<Failure, IncomingSocketMessage>> call() {
    return repository.messageStream;
  }
}
