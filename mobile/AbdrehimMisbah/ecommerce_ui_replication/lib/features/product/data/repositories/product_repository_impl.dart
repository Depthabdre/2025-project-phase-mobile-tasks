import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    // TODO: implement
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    // TODO: implement
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, Unit>> createProduct(Product product) async {
    // TODO: implement
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(Product product) async {
    // TODO: implement
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(int id) async {
    // TODO: implement
    return Left(ServerFailure());
  }
}
