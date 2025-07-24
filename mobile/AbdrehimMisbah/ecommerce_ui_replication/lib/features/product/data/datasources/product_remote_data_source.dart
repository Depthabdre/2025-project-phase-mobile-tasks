import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  /// Calls the API to get all products.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ProductModel>> getAllProducts();

  /// Calls the API to get a product by ID.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ProductModel> getProductById(int id);

  /// Posts product to the API.
  Future<void> createProduct(ProductModel product);

  /// Updates product on the API.
  Future<void> updateProduct(ProductModel product);

  /// Deletes product from the API.
  Future<void> deleteProduct(int id);
}
