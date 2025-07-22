import 'package:flutter/material.dart';

import 'addUpdate.dart';
import 'details.dart';
import 'product_data.dart';
// <-- import your product list and class
import 'reusable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HomePage(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            );

          case '/details':
            final product = settings.arguments as Product;
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProductDetailsPage(product: product),
              transitionsBuilder: (_, animation, __, child) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide from right
                  end: Offset.zero,
                ).animate(animation);

                return SlideTransition(position: offsetAnimation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            );

          case '/update':
            final product = settings.arguments as Product?;
            return PageRouteBuilder<Product>(
              pageBuilder: (_, __, ___) => AddUpdatePage(product: product),
              transitionsBuilder: (_, animation, __, child) {
                final scaleAnimation = Tween<double>(
                  begin: 0.95,
                  end: 1.0,
                ).animate(animation);

                return ScaleTransition(
                  scale: scaleAnimation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
            );
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Product> products;

  @override
  void initState() {
    super.initState();
    products = List.from(initialProducts);
  }

  // Navigate to Add Product
  void goToAddProductPage(BuildContext context) async {
    final result = await Navigator.pushNamed<Product>(
      context,
      '/update',
      arguments: null, // null = add new
    );
    if (result != null) {
      setState(() {
        // Check if product with same name exists
        final index = products.indexWhere(
          (product) => product.name == result.name,
        );

        if (index != -1) {
          // Product exists, update it
          products[index] = result;
        } else {
          // Product doesn't exist, add it
          products.add(result);
        }
      });
    }
  }

  Widget productHeading() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Available Products',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3E3E3E), // Hex color #3E3E3E
            ),
          ),
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(
                8,
              ), // optional rounded corners
            ),
            child: Icon(Icons.search, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget userIntro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Container(
          width: 50, // Container width
          height: 50, // Container height
          decoration: BoxDecoration(
            color: const Color(0xFFCCCCCC), // Fill color
            borderRadius: BorderRadius.circular(6), // Rounded corners
          ),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'July 17, 2025',
              style: TextStyle(
                fontFamily: 'Syne', // Use Syne font
                fontWeight: FontWeight.w500, // Medium weight
                fontSize: 12,
                color: Color(0xFFAAAAAA), // Hex color #AAAAAA
              ),
            ),
            SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: 'Hello, ',
                style: TextStyle(
                  fontFamily: 'Sora', // Use Sora font
                  fontWeight: FontWeight.w400, // Regular weight
                  fontSize: 10,
                  color: Color(0xFFAAAAAA),
                ), // Default style

                children: [
                  TextSpan(
                    text: 'Yohannes',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'sora',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: userIntro(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              productHeading(),
              const SizedBox(height: 8),
              ...productCard(
                context: context,
                products: products,
                onDelete: (productName) {
                  setState(() {
                    products.removeWhere((p) => p.name == productName);
                  });
                },
                onUpdate: (updatedProduct) {
                  setState(() {
                    final index = products.indexWhere(
                      (p) => p.name == updatedProduct.name,
                    );
                    if (index != -1) {
                      products[index] = updatedProduct;
                    } else {
                      products.add(updatedProduct);
                    }
                  });
                },
              ),
            ],
          ),

          // Floating button absolutely positioned
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  // Your action
                  goToAddProductPage(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
