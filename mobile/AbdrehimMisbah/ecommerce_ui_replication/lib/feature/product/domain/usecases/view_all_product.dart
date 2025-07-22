import '../repositories/product_repository.dart';
import '../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/product.dart';

class ViewAllProductsUsecase {
  final ProductRepository repository;

  ViewAllProductsUsecase(this.repository);

  // This makes the class "callable"
  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getAllProducts();
  }
}
