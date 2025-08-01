import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(); // No constructor logic needed

  @override
  List<Object?> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}
