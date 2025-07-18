import 'package:flutter/material.dart';
import 'product_data.dart'; // <-- import your product list and class
import 'details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductDetailsPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget productHeading() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
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
            padding: EdgeInsets.all(4),
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

  List<Widget> productCard() {
    List<Widget> headingAndProductCard = [];

    // Add heading widget
    // headingAndProductCard.add(productHeading());

    // Add product cards
    headingAndProductCard.addAll(
      products.map((product) {
        return Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product Image
              AspectRatio(
                aspectRatio: 18 / 11,
                child: Image.asset(product.image, fit: BoxFit.fitWidth),
              ),
              const SizedBox(height: 8),

              // Name + Price
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins', // Custom font family
                        fontSize: 20,
                        fontWeight: FontWeight.w500, // Medium weight
                        color: Color(0xFF3E3E3E), // Hex color #3E3E3E
                      ),
                    ),

                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins', // Custom font family
                        fontSize: 14,
                        fontWeight: FontWeight.w500, // Medium weight
                        color: Color(0xFF3E3E3E),
                      ),
                    ),
                  ],
                ),
              ),

              // Type + Rating
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.type,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins', // Use Poppins font
                        fontWeight: FontWeight.w400, // Regular weight
                        color: Color(0xFFAAAAAA), // Hex color #AAAAAA
                      ),
                    ),

                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.star,
                              color: Color(0xFFFFD700),
                              size: 20,
                            ),
                          ),
                          WidgetSpan(
                            child: SizedBox(width: 4), // spacing
                          ),
                          TextSpan(
                            text: '(${product.rating})',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Sora', // Use Sora font
                              fontWeight: FontWeight.w400, // Regular weight
                              color: Color(0xFFAAAAAA), // Hex color #AAAAAA
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      }).toList(), // 👈 make sure this ends without a comma
    );

    return headingAndProductCard;
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
            color: Color(0xFFCCCCCC), // Fill color
            borderRadius: BorderRadius.circular(6), // Rounded corners
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'July 17, 2025',
              style: const TextStyle(
                fontFamily: 'Syne', // Use Syne font
                fontWeight: FontWeight.w500, // Medium weight
                fontSize: 12,
                color: Color(0xFFAAAAAA), // Hex color #AAAAAA
              ),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: 'Hello, ',
                style: const TextStyle(
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
            children: [productHeading(), SizedBox(height: 8), ...productCard()],
          ),

          // Floating button absolutely positioned
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  // Your action
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
