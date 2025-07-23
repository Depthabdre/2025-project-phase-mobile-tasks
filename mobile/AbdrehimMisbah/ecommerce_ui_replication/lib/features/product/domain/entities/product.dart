import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String imageUrl;
  final String name;
  final double price;
  final String description;

  const Product({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  List<Object> get props => [id];

  // Factory constructor to create a Product instance from a JSON map.
  // This is commonly used when parsing API response data.
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    imageUrl: json['imageUrl'],
    name: json['name'],
    price: json['price'],
    description: json['description'],
  );
  // Converts a Product instance into a JSON map.
  // This is useful when sending data to an API or saving it locally.
  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'name': name,
    'price': price,
    'description': description,
  };
}
