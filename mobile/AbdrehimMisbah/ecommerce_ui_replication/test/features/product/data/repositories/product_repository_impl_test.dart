import 'package:dartz/dartz.dart';
import 'package:ecommerce_ui_replication/core/platform/network_info.dart';
import 'package:ecommerce_ui_replication/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_ui_replication/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_ui_replication/features/product/data/models/product_model.dart';
import 'package:ecommerce_ui_replication/features/product/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_ui_replication/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ProductRemoteDataSource, ProductLocalDataSource, NetworkInfo])
import 'product_repository_impl_test.mocks.dart';

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // We'll add actual tests in the next steps (e.g. for createProduct)

  group('createProduct', () {
    final testProduct = const Product(
      id: 1,
      imageUrl: 'https://example.com/img.png',
      name: 'Test Product',
      price: 99.99,
      description: 'Test description',
    );

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // act
      repository.createProduct(testProduct);

      // assert
      verify(mockNetworkInfo.isConnected);
    });
  });
  group('device is online', () {
    // Runs before each test in this group
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should return remote data (Right(unit)) when remote data source succeeds',
      () async {
        // Arrange
        final testProduct = const ProductModel(
          id: 1,
          imageUrl: 'https://example.com/image.png',
          name: 'Test Product',
          price: 99.99,
          description: 'Test description',
        );

        when(
          mockRemoteDataSource.createProduct(testProduct),
        ).thenAnswer((_) async => unit); // simulate success

        // Act
        final result = await repository.createProduct(testProduct);

        // Assert
        verify(mockRemoteDataSource.createProduct(testProduct));
        expect(result, equals(const Right(unit)));
      },
    );
  });
}
