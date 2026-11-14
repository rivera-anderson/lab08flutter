import 'package:flutter/cupertino.dart';

/// Modelo de datos para representar un Producto en la tienda.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final IconData icon;
  final Color color;

  /// URL de la foto del producto. Si es null o no carga, se muestra el ícono.
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.category = 'Electrónica',
    this.icon = CupertinoIcons.cube_box,
    this.color = const Color(0xFF007AFF),
    this.imageUrl,
  });

  /// Precio listo para mostrar: "S/ 80" o "S/ 79.90".
  String get priceLabel => price.truncateToDouble() == price
      ? 'S/ ${price.toInt()}'
      : 'S/ ${price.toStringAsFixed(2)}';
}
