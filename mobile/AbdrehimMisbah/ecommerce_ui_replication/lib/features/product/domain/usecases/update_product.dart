import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUsecase extends UseCase<Unit, Params> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Params params) async {
    return await repository.updateProduct(params.product);
  }
}

class Params {
  final Product product;

  Params(this.product);
}
