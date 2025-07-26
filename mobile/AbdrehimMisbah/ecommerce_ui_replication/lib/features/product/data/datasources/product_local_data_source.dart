import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
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

// ignore: constant_identifier_names
const CACHED_PRODUCT_LIST = 'CACHED_PRODUCT_LIST';

// ✅ IMPLEMENTATION
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getLastProductList() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCT_LIST);

    if (jsonString != null) {
      final List<dynamic> decodedJson = json.decode(jsonString);
      final List<ProductModel> productList = decodedJson
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return Future.value(productList);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<ProductModel> getProductById(int id) {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCT_LIST');

    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);

      try {
        final productMap = decodedList.firstWhere(
          (item) => item['id'] == id,
          orElse: () => throw CacheException(),
        );

        return Future.value(ProductModel.fromJson(productMap));
      } catch (e) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheProductList(List<ProductModel> products) {
    final jsonString = json.encode(products.map((p) => p.toJson()).toList());
    return sharedPreferences.setString('CACHED_PRODUCT_LIST', jsonString);
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCT_LIST');
    List<ProductModel> currentList = [];

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      currentList = jsonList
          .map((item) => ProductModel.fromJson(item))
          .toList();
    }

    // Remove any product with same ID (to avoid duplicates)
    currentList.removeWhere((p) => p.id == product.id);

    // Add the new product
    currentList.add(product);

    final updatedJson = json.encode(
      currentList.map((p) => p.toJson()).toList(),
    );

    await sharedPreferences.setString('CACHED_PRODUCT_LIST', updatedJson);
  }

  @override
  Future<void> deleteProduct(int id) async {
    final jsonString = sharedPreferences.getString('CACHED_PRODUCT_LIST');

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<ProductModel> currentList = jsonList
          .map((item) => ProductModel.fromJson(item))
          .toList();

      final updatedList = currentList
          .where((product) => product.id != id)
          .toList();

      final updatedJson = json.encode(
        updatedList.map((product) => product.toJson()).toList(),
      );

      await sharedPreferences.setString('CACHED_PRODUCT_LIST', updatedJson);
    } else {
      throw CacheException();
    }
  }
}
