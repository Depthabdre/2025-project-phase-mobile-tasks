class Product {
  final String image;
  final String name;
  final String type;
  final double rating;
  final double price;
  final String description; // 👈 Added

  Product({
    required this.image,
    required this.name,
    required this.type,
    required this.rating,
    required this.price,
    required this.description, // 👈 Added
  });
}

List<Product> initialProducts = [
  Product(
    image: 'images/leather_shoe1.jpeg',
    name: 'Classic Leather Shoe',
    type: 'Men\'s Shoes',
    rating: 4.7,
    price: 89.99,
    description:
        "Elegant and durable leather shoes perfect for formal occasions or daily wear. Crafted from premium genuine leather, they offer both sophistication and long-lasting performance. The sleek design pairs effortlessly with suits, chinos, or even smart-casual jeans, making them a versatile choice for any wardrobe. A cushioned insole and breathable lining ensure all-day comfort, whether you're in the office or out for a night on the town. ",
  ),
  Product(
    image: 'images/tshirt_men1.jpeg',
    name: 'Slim Fit T-Shirt',
    type: 'Men\'s T-Shirts',
    rating: 4.3,
    price: 29.99,
    description:
        'Comfortable slim fit t-shirt made from high-quality cotton, great for everyday style.', // 👈
  ),
  Product(
    image: 'images/phone1.jpeg',
    name: 'Smartphone X12',
    type: 'Smartphones',
    rating: 4.8,
    price: 699.00,
    description:
        'Powerful smartphone with a stunning display, long battery life, and top-tier camera.', // 👈
  ),
  Product(
    image: 'images/sofa1.jpg',
    name: 'Cozy Sofa',
    type: 'Furniture',
    rating: 4.6,
    price: 449.50,
    description:
        'Modern and comfortable sofa designed to add elegance and relaxation to any living room.', // 👈
  ),
];
