// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/view_product_by_id_usecase.dart';
import '../../domain/usecases/view_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final CreateProductUsecase createProduct;
  final DeleteProductUsecase deleteProduct;
  final UpdateProductUsecase updateProduct;
  final ViewProductUsecase viewProduct;
  final ViewProductByIdUsecase viewSingleProduct;
  final InputConverter inputConverter;

  ProductBloc({
    required this.createProduct,
    required this.deleteProduct,
    required this.updateProduct,
    required this.viewProduct,
    required this.viewSingleProduct,
    required this.inputConverter,
  }) : super(ProductInitial()) {
    on<AddProduct>((event, emit) {
      // TODO: implement event handler
      final priceString = event.product.price.toString();
      final inputEither = inputConverter.stringToUnsignedInteger(priceString);
    });
  }
}
