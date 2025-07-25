import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  /// Gets the cached list of [ProductModel] from the last API call.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<ProductModel>> getLastProductList();

  /// Gets the cached [ProductModel] by its ID.
  ///
  /// Throws [CacheException] if the product is not found.
  Future<ProductModel> getProductById(int id);

  /// Caches a list of products for later retrieval.
  Future<void> cacheProductList(List<ProductModel> products);

  /// Caches a single product.
  Future<void> cacheProduct(ProductModel product);

  /// Deletes a cached product by ID.
  Future<void> deleteProduct(int id);
}
