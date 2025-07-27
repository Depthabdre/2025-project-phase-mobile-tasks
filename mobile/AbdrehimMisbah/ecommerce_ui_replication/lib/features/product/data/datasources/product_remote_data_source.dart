import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';
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

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  Future<Map<String, dynamic>> _getJsonFromUrl(Uri url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw ServerException();
    }
  }

  Future<List<Map<String, dynamic>>> _getListFromUrl(Uri url) async {
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final jsonList = await _getListFromUrl(
      Uri.parse('https://api.yourapp.com/products'),
    );
    return jsonList.map((jsonMap) => ProductModel.fromJson(jsonMap)).toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final jsonMap = await _getJsonFromUrl(
      Uri.parse('https://api.yourapp.com/products/$id'),
    );
    return ProductModel.fromJson(jsonMap);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse('https://api.yourapp.com/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return; // success, just complete the Future<void>
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('https://api.yourapp.com/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    final response = await client.delete(
      Uri.parse('https://api.yourapp.com/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw ServerException();
    }
  }
}
