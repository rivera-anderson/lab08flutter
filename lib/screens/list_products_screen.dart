import 'dart:ui' show ImageFilter;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/app_state.dart';
import 'add_product_screen.dart';

/// [ListProductsScreen] - Catálogo KROMA con tarjeta de métricas superior inspirada en GROSS REVENUE
/// y tarjetas de productos en modo oscuro neo-grotesco de alto contraste.
class ListProductsScreen extends StatefulWidget {
  const ListProductsScreen({super.key});

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = '';
  String _selectedCategory = 'Todos';

  final List<String> _categories = ['Todos', 'Computadoras', 'Accesorios', 'Pantallas'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showProductDetails(Product product) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF202227),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withAlpha(20),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(90),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: product.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(product.icon, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5CD8A6).withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'EN STOCK • ORIGINAL',
                            style: TextStyle(
                              color: Color(0xFF5CD8A6),
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Precio en Tarjeta Coral o Periwinkle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF141518),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PRECIO DE VENTA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9EA3AE),
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      'S/ ${product.price.toStringAsFixed(product.price.truncateToDouble() == product.price ? 0 : 2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF6548),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'DESCRIPCIÓN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF9EA3AE),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 26),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: CupertinoButton(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Cerrar Ficha',
                    style: TextStyle(
                      color: Color(0xFF141518),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF141518),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Barra superior con botón circular de retroceso (←) como en la referencia
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Color(0xFF141518),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'LISTAR PRODUCTOS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const AddProductScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6548),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.plus,
                        color: Color(0xFF141518),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Contenido Scrollable
            Expanded(
              child: ListenableBuilder(
                listenable: appState,
                builder: (context, _) {
                  final allProducts = appState.products;
                  final totalValue = allProducts.fold<double>(0, (sum, p) => sum + p.price);

                  final filtered = allProducts.where((p) {
                    final matchesQuery = p.name.toLowerCase().contains(_filterQuery);
                    final matchesCategory = _selectedCategory == 'Todos' ||
                        p.category.toLowerCase() == _selectedCategory.toLowerCase();
                    return matchesQuery && matchesCategory;
                  }).toList();

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      // Tarjeta de Métricas estilo "GROSS REVENUE" de la referencia
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6548),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6548).withAlpha(80),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'VALOR TOTAL DE INVENTARIO',
                                  style: TextStyle(
                                    color: Color(0xFF141518),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF141518),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${allProducts.length} ITEMS',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'S/ ${totalValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFF141518),
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Actualizado en tiempo real con KROMA OS',
                              style: TextStyle(
                                color: const Color(0xFF141518).withAlpha(180),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Barra de Búsqueda tipo Píldora
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF202227),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withAlpha(15),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.search,
                              color: Color(0xFF9EA3AE),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Buscar productos...',
                                  hintStyle: TextStyle(color: Color(0xFF565B67)),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  fillColor: Colors.transparent,
                                ),
                                onChanged: (val) {
                                  setState(() => _filterQuery = val.trim().toLowerCase());
                                },
                              ),
                            ),
                            if (_searchController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() => _filterQuery = '');
                                },
                                child: const Icon(
                                  CupertinoIcons.clear_thick_circled,
                                  size: 18,
                                  color: Color(0xFF9EA3AE),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Chips de Categoría
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _categories.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isSelected = _selectedCategory == cat;

                            return GestureDetector(
                              onTap: () => setState(() => _selectedCategory = cat),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : const Color(0xFF202227),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected ? const Color(0xFF141518) : Colors.white70,
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Lista de Tarjetas de Productos
                      if (filtered.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: const Center(
                            child: Text(
                              'No hay productos que coincidan',
                              style: TextStyle(
                                color: Color(0xFF9EA3AE),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      else
                        ...filtered.map((product) {
                          final priceText = product.price.truncateToDouble() == product.price
                              ? 'S/ ${product.price.toInt()}'
                              : 'S/ ${product.price.toStringAsFixed(2)}';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Dismissible(
                              key: ValueKey(product.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 22),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF453A),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(CupertinoIcons.trash, color: Colors.white, size: 24),
                              ),
                              onDismissed: (_) {
                                appState.removeProduct(product.id);
                              },
                              child: GestureDetector(
                                onTap: () => _showProductDetails(product),
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF202227),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withAlpha(12),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Ícono con fondo de color distintivo
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: product.color,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(
                                          product.icon,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Nombre y categoría
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              product.category,
                                              style: const TextStyle(
                                                color: Color(0xFF9EA3AE),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Precio y botón circular
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            priceText,
                                            style: const TextStyle(
                                              color: Color(0xFFF7B944),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -0.4,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(20),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              CupertinoIcons.arrow_up_right,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
