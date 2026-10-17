import 'package:flutter/material.dart';

/// Modelo de datos para representar un Producto.
/// Contiene nombre, descripción, precio y metadatos visuales para el estilo iOS.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final Color color;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.icon = Icons.devices_rounded,
    this.color = const Color(0xFF007AFF),
  });
}
