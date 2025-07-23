import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failure.dart';

/// Base UseCase class with generics for flexible input and output types.
/// Enforces a `call` method to keep use cases consistent.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Empty parameter class for use cases that don't need input parameters.
/// Extends Equatable to support value equality (useful in testing, Bloc, etc).
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
