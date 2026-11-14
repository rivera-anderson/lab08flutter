import 'package:flutter/cupertino.dart';
import '../models/product.dart';
import '../models/product_images.dart';
import '../models/user_profile.dart';

/// [AppState] Administrador reactivo global tipo Singleton.
/// Mantiene sincronizadas todas las pantallas mediante el patrón Observer nativo.
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;

  AppState._internal() {
    _initDefaultData();
  }

  final List<Product> _products = [];
  List<Product> get products => List.unmodifiable(_products);

  UserProfile _userProfile = UserProfile(
    name: 'Juan Pérez',
    email: 'juan@email.com',
    phone: '987 654 321',
  );
  UserProfile get userProfile => _userProfile;

  void _initDefaultData() {
    _products.addAll([
      Product(
        id: '1',
        name: 'Laptop',
        description: 'Apple MacBook Pro con chip M3 Pro, 18GB de memoria unificada y pantalla Liquid Retina XDR.',
        price: 2500.0,
        category: 'Computadoras',
        icon: CupertinoIcons.device_laptop,
        color: const Color(0xFF007AFF),
        imageUrl: ProductImages.laptop,
      ),
      Product(
        id: '2',
        name: 'Mouse',
        description: 'Magic Mouse inalámbrico recargable con superficie Multi-Touch optimizada.',
        price: 80.0,
        category: 'Accesorios',
        icon: CupertinoIcons.device_laptop,
        color: const Color(0xFF5856D6),
        imageUrl: ProductImages.mouse,
      ),
      Product(
        id: '3',
        name: 'Teclado',
        description: 'Magic Keyboard con Touch ID y teclado numérico en acabado aluminio espacial.',
        price: 120.0,
        category: 'Accesorios',
        icon: CupertinoIcons.keyboard,
        color: const Color(0xFFFF9500),
        imageUrl: ProductImages.keyboard,
      ),
      Product(
        id: '4',
        name: 'Monitor',
        description: 'Studio Display de 27 pulgadas con resolución 5K Retina, cámara de 12MP y audio espacial.',
        price: 900.0,
        category: 'Pantallas',
        icon: CupertinoIcons.tv,
        color: const Color(0xFF34C759),
        imageUrl: ProductImages.monitor,
      ),
    ]);
  }

  void addProduct({
    required String name,
    required String description,
    required double price,
    String category = 'Electrónica',
    IconData icon = CupertinoIcons.cube_box,
    Color color = const Color(0xFF007AFF),
    String? imageUrl,
  }) {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description.isEmpty ? 'Sin descripción detallada' : description,
      price: price,
      category: category,
      icon: icon,
      color: color,
      imageUrl: imageUrl,
    );

    _products.insert(0, newProduct);
    notifyListeners();
  }

  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

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
