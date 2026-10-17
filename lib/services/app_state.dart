import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/user_profile.dart';

/// [AppState] Administrador de estado global de la aplicación.
/// Utiliza ChangeNotifier (patrón Observer nativo de Flutter)
/// para notificar automáticamente a las vistas cuando se agregan productos
/// o se actualiza el perfil del usuario, evitando recargar toda la app.
class AppState extends ChangeNotifier {
  // Patrón Singleton para acceder a la misma instancia desde cualquier pantalla
  static final AppState instance = AppState._internal();
  factory AppState() => instance;

  AppState._internal() {
    _initDefaultData();
  }

  // Lista de productos en memoria
  final List<Product> _products = [];
  List<Product> get products => List.unmodifiable(_products);

  // Perfil del usuario inicial
  UserProfile _userProfile = UserProfile(
    name: 'Juan Pérez',
    email: 'juan@email.com',
    phone: '987 654 321',
  );
  UserProfile get userProfile => _userProfile;

  /// Inicializa los datos requeridos en la guía del laboratorio:
  /// Laptop (S/ 2500), Mouse (S/ 80), Teclado (S/ 120), Monitor (S/ 900)
  void _initDefaultData() {
    _products.addAll([
      Product(
        id: '1',
        name: 'Laptop',
        description: 'Potente laptop para desarrollo y diseño.',
        price: 2500.0,
        icon: Icons.laptop_mac_rounded,
        color: const Color(0xFF007AFF),
      ),
      Product(
        id: '2',
        name: 'Mouse',
        description: 'Mouse inalámbrico ergonómico de alta precisión.',
        price: 80.0,
        icon: Icons.mouse_rounded,
        color: const Color(0xFF5856D6),
      ),
      Product(
        id: '3',
        name: 'Teclado',
        description: 'Teclado mecánico con retroiluminación y switches táctiles.',
        price: 120.0,
        icon: Icons.keyboard_rounded,
        color: const Color(0xFFFF9500),
      ),
      Product(
        id: '4',
        name: 'Monitor',
        description: 'Monitor 4K IPS de 27 pulgadas con bordes ultradelgados.',
        price: 900.0,
        icon: Icons.desktop_mac_rounded,
        color: const Color(0xFF34C759),
      ),
    ]);
  }

  /// Registra un nuevo producto y notifica a las pantallas suscritas
  void addProduct({
    required String name,
    required String description,
    required double price,
  }) {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description.isEmpty ? 'Sin descripción' : description,
      price: price,
      icon: Icons.inventory_2_rounded,
      color: const Color(0xFF007AFF),
    );

    // Insertar al inicio de la lista para visibilidad inmediata
    _products.insert(0, newProduct);
    notifyListeners();
  }

  /// Elimina un producto por su identificador
  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  /// Actualiza los datos del perfil de usuario
  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    _userProfile = _userProfile.copyWith(
      name: name,
      email: email,
      phone: phone,
    );
    notifyListeners();
  }
}
