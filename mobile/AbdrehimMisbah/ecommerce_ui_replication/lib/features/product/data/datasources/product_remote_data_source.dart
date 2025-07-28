import 'dart:convert';
import 'dart:io';

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
  Future<ProductModel> getProductById(String id);

  /// Posts product to the API.
  Future<void> createProduct(ProductModel product);

  /// Updates product on the API.
  Future<void> updateProduct(ProductModel product);

  /// Deletes product from the API.
  Future<void> deleteProduct(String id);
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
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];
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
  Future<ProductModel> getProductById(String id) async {
    final jsonMap = await _getJsonFromUrl(
      Uri.parse(
        'https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$id',
      ),
    );

    final data = jsonMap['data'] as Map<String, dynamic>;

    return ProductModel.fromJson(data);
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final uri = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/api/v1/products',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['name'] = product.name
      ..fields['description'] = product.description
      ..fields['price'] = product.price.toString();

    final imageFile = File(product.imageUrl);
    if (!await imageFile.exists()) {
      throw Exception('Image file not found at path: ${imageFile.path}');
    }

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    // Use the injected client to send the request so we can mock it in tests
    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/api/v1/products/${product.id}',
    );

    final body = json.encode({
      'name': product.name,
      'description': product.description,
      'price': product.price,
    });

    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse(
        'https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$id',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
