import 'package:flutter/material.dart';
import 'product_data.dart'; // <-- import your product list and class
import 'details.dart';

List<Widget> productCard({
  required BuildContext context,
  required List<Product> products,
  bool isInDetailPage = false,
  void Function(String productName)? onDelete, // 👈 Add this
}) {
  List<Widget> productCard = [];

  // Add heading widget
  // ProductCard.add(productHeading());

  // Add product cards
  productCard.addAll(
    products.map((product) {
      return GestureDetector(
        onTap: () async {
          if (!isInDetailPage) {
            final result = await Navigator.pushNamed(
              context,
              '/details',
              arguments: product,
            );

            if (result != null &&
                result is Map &&
                result['action'] == 'delete') {
              onDelete!(result['productName']);
            }
          }
        },

        child: Card(
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
        ),
      );
    }).toList(), // 👈 make sure this ends without a comma
  );

  return productCard;
}

Widget buildLabelText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      fontFamily: 'Poppins',
    ),
  );
}

/// A function that returns a styled input box widget.
Widget buildInputBox() {
  return TextField(
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    ),
  );
}
