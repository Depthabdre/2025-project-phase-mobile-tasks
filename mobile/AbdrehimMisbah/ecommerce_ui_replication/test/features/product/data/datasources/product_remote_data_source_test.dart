import 'dart:convert';

import 'package:ecommerce_ui_replication/core/error/exception.dart';
import 'package:ecommerce_ui_replication/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_ui_replication/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  // ✅ These helper methods are defined inside main(), but OUTSIDE test()
  void setUpMockHttpClientSuccess200() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture('product.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  void setUpMockHttpClientSuccess200WithList() {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture('product_list.json'), 200));
  }

  group('getProductById', () {
    final tId = 1;

    test(
      'should perform a GET request with product ID in the URL and application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        await dataSource.getProductById(tId);

        // assert
        verify(
          mockHttpClient.get(
            Uri.parse('https://api.yourapp.com/products/$tId'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );
    final tProductModel = ProductModel.fromJson(
      json.decode(fixture('product.json')),
    );

    test(
      'should return ProductModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSource.getProductById(1);

        // assert
        expect(result, equals(tProductModel));
      },
    );
    test(
      'should throw ServerException when the response code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getProductById;

        // assert
        expect(() => call(1), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('getAllProducts', () {
    final List<dynamic> jsonList = json.decode(fixture('product_list.json'));

    final tProductModelList = jsonList
        .map((jsonItem) => ProductModel.fromJson(jsonItem))
        .toList();

    test(
      'should perform a GET request on /products with application/json header',
      () async {
        setUpMockHttpClientSuccess200WithList();

        await dataSource.getAllProducts();

        verify(
          mockHttpClient.get(
            Uri.parse('https://api.yourapp.com/products'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test(
      'should return list of ProductModels when response code is 200',
      () async {
        setUpMockHttpClientSuccess200WithList();

        final result = await dataSource.getAllProducts();

        expect(result, equals(tProductModelList));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        setUpMockHttpClientFailure404();

        final call = dataSource.getAllProducts;

        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('createProduct', () {
    final tProductModel = const ProductModel(
      id: 1,
      name: 'Test Product',
      imageUrl: 'https://example.com/image.png',
      price: 9.99,
      description: 'Test Description',
    );

    void setUpMockHttpClientSuccess() {
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 201)); // Success status code
    }

    void setUpMockHttpClientFailure() {
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Error', 400),
      ); // Failure status code
    }

    test(
      'should perform a POST request with correct URL, headers, and body',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        await dataSource.createProduct(tProductModel);

        // assert
        final expectedJsonBody = json.encode(tProductModel.toJson());

        verify(
          mockHttpClient.post(
            Uri.parse('https://api.yourapp.com/products'),
            headers: {'Content-Type': 'application/json'},
            body: expectedJsonBody,
          ),
        );
      },
    );

    test('should complete normally when response is 201 (success)', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      final call = dataSource.createProduct(tProductModel);

      // assert
      expect(call, completes);
    });

    test(
      'should throw ServerException when response code is not 201',
      () async {
        // arrange
        setUpMockHttpClientFailure();

        // act
        final call = dataSource.createProduct;

        // assert
        expect(() => call(tProductModel), throwsA(isA<ServerException>()));
      },
    );
  });

  group('updateProduct', () {
    final tProductModel = const ProductModel(
      id: 1,
      name: 'Updated Product',
      imageUrl: 'https://example.com/image.png',
      price: 19.99,
      description: 'Updated Description',
    );

    void setUpMockHttpClientSuccess() {
      when(
        mockHttpClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('', 200));
    }

    void setUpMockHttpClientFailure() {
      when(
        mockHttpClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Error', 400));
    }

    test(
      'should perform a PUT request with correct URL, headers, and body',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        await dataSource.updateProduct(tProductModel);

        // assert
        final expectedJsonBody = json.encode(tProductModel.toJson());

        verify(
          mockHttpClient.put(
            Uri.parse('https://api.yourapp.com/products/${tProductModel.id}'),
            headers: {'Content-Type': 'application/json'},
            body: expectedJsonBody,
          ),
        );
      },
    );

    test(
      'should complete normally when response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        final call = dataSource.updateProduct(tProductModel);

        // assert
        expect(call, completes);
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure();

        // act
        final call = dataSource.updateProduct;

        // assert
        expect(() => call(tProductModel), throwsA(isA<ServerException>()));
      },
    );
  });

  group('deleteProduct', () {
    final tId = 1;

    void setUpMockHttpClientSuccess() {
      when(
        mockHttpClient.delete(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('', 200));
    }

    void setUpMockHttpClientFailure() {
      when(
        mockHttpClient.delete(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Error', 404));
    }

    test(
      'should perform a DELETE request with correct URL and headers',
      () async {
        // arrange
        setUpMockHttpClientSuccess();

        // act
        await dataSource.deleteProduct(tId);

        // assert
        verify(
          mockHttpClient.delete(
            Uri.parse('https://api.yourapp.com/products/$tId'),
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );

    test('should complete normally when response code is 200', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      final call = dataSource.deleteProduct(tId);

      // assert
      expect(call, completes);
    });

    test(
      'should throw ServerException when the response code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure();

        // act
        final call = dataSource.deleteProduct;

        // assert
        expect(() => call(tId), throwsA(isA<ServerException>()));
      },
    );
  });
}
