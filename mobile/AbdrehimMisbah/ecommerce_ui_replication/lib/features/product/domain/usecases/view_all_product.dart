import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUsecase extends UseCase<Product, Params> {
  final ProductRepository repository;

  ViewProductUsecase(this.repository);

  @override
  Future<Either<Failure, Product>> call(Params params) async {
    return await repository.getProductById(params.id);
  }
}

// Params class for input
class Params {
  final String id;

  Params(this.id);
}
