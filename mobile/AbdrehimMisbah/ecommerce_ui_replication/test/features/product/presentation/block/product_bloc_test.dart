import 'package:dartz/dartz.dart';
import 'package:ecommerce_ui_replication/core/util/input_converter.dart';
import 'package:ecommerce_ui_replication/features/product/domain/entities/product.dart';
import 'package:ecommerce_ui_replication/features/product/domain/usecases/create_product_usecase.dart';
import 'package:ecommerce_ui_replication/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:ecommerce_ui_replication/features/product/domain/usecases/update_product_usecase.dart';
import 'package:ecommerce_ui_replication/features/product/domain/usecases/view_product_by_id_usecase.dart';
import 'package:ecommerce_ui_replication/features/product/domain/usecases/view_product_usecase.dart';
import 'package:ecommerce_ui_replication/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  CreateProductUsecase,
  DeleteProductUsecase,
  UpdateProductUsecase,
  ViewProductUsecase,
  ViewProductByIdUsecase,
  InputConverter,
])
void main() {
  late ProductBloc bloc;
  late MockCreateProductUsecase mockCreateProduct;
  late MockDeleteProductUsecase mockDeleteProduct;
  late MockUpdateProductUsecase mockUpdateProduct;
  late MockViewProductUsecase mockViewProducts;
  late MockViewProductByIdUsecase mockViewProductById;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockCreateProduct = MockCreateProductUsecase();
    mockDeleteProduct = MockDeleteProductUsecase();
    mockUpdateProduct = MockUpdateProductUsecase();
    mockViewProducts = MockViewProductUsecase();
    mockViewProductById = MockViewProductByIdUsecase();
    mockInputConverter = MockInputConverter();
    bloc = ProductBloc(
      createProduct: mockCreateProduct,
      deleteProduct: mockDeleteProduct,
      updateProduct: mockUpdateProduct,
      viewProduct: mockViewProducts,
      viewSingleProduct: mockViewProductById,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be ProductInitial', () {
    // assert
    expect(bloc.state, equals(ProductInitial()));
  });

  // You'll add blocTest() here to test specific events and states

  group('CreateProductEvent', () {
    // This is the product coming from the UI (e.g. a form)
    final tProduct = const Product(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      imageUrl: 'https://example.com/image.png',
    );
    test(
      'should call the InputConverter to validate and convert the product price from string',
      () async {
        // arrange
        const inputPrice = '199.0';
        final parsedPrice = 199;

        when(
          mockInputConverter.stringToUnsignedInteger(any),
        ).thenReturn(Right(parsedPrice));

        final product = Product(
          id: '1',
          imageUrl: 'https://example.com/image.png',
          name: 'Test Product',
          price: parsedPrice.toDouble(), // we convert it here
          description: 'A sample product for testing',
        );

        // act
        bloc.add(AddProduct(product));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        // assert
        verify(mockInputConverter.stringToUnsignedInteger(inputPrice));
      },
    );
  });
}
