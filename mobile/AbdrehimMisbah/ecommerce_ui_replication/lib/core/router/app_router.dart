import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/product/domain/entities/product.dart';
import '../../../features/product/injection_container.dart'; // for sl<ProductBloc>()
import '../../../features/product/presentation/bloc/product_bloc.dart';
import '../../../features/product/presentation/pages/add_update_product_page.dart';
import '../../../features/product/presentation/pages/product_details_page.dart';
import '../../features/product/presentation/pages/retrieve_all_products_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProductBloc>()..add(const LoadAllProductEvent()),
            child: const RetrieveAllProductsPage(),
          ),
        );

      case '/detail':
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                sl<ProductBloc>()..add(GetSingleProductEvent(productId)),
            child: ProductDetailsPage(productId: productId),
          ),
        );

      case '/create':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProductBloc>(),
            child: const AddUpdateProductPage(isEditing: false),
          ),
        );

      case '/update':
        final Product product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ProductBloc>(),
            child: AddUpdateProductPage(isEditing: true, product: product),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
