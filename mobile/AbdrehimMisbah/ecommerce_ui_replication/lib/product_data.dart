class Product {
  final String image;
  final String name;
  final String type;
  final double rating;
  final double price; // 👈 Added

  Product({
    required this.image,
    required this.name,
    required this.type,
    required this.rating,
    required this.price, // 👈 Added
  });
}

List<Product> products = [
  Product(
    image: 'images/leather_shoe1.jpeg',
    name: 'Classic Leather Shoe',
    type: 'Men\'s Shoes',
    rating: 4.7,
    price: 89.99,
  ),
  Product(
    image: 'images/tshirt_men1.jpeg',
    name: 'Slim Fit T-Shirt',
    type: 'Men\'s T-Shirts',
    rating: 4.3,
    price: 29.99,
  ),
  Product(
    image: 'images/phone1.jpeg',
    name: 'Smartphone X12',
    type: 'Smartphones',
    rating: 4.8,
    price: 699.00,
  ),
  Product(
    image: 'images/sofa1.jpg',
    name: 'Cozy Sofa',
    type: 'Furniture',
    rating: 4.6,
    price: 449.50,
  ),
];
