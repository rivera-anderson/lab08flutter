import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';

/// [AddProductScreen] - Pantalla de REGISTRAR PRODUCTOS con tarjeta de vista previa en tiempo real.
/// A medida que el usuario escribe el Nombre, Descripción y Precio, la vista previa superior
/// se actualiza de manera instantánea como en las apps profesionales de Apple.
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedCategory = 'Computadoras';
  bool _isSaving = false;
  bool _isButtonPressed = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Computadoras',
      'icon': CupertinoIcons.device_laptop,
      'color': const Color(0xFF007AFF),
    },
    {
      'name': 'Accesorios',
      'icon': CupertinoIcons.keyboard,
      'color': const Color(0xFF5856D6),
    },
    {
      'name': 'Pantallas',
      'icon': CupertinoIcons.tv,
      'color': const Color(0xFF34C759),
    },
    {
      'name': 'Otros',
      'icon': CupertinoIcons.cube_box,
      'color': const Color(0xFFFF9500),
    },
  ];

  @override
  void initState() {
    super.initState();
    // Escucha cambios para actualizar la tarjeta de vista previa en caliente
    _nameController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
    _priceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 700));

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.parse(_priceController.text.trim());

    final activeCat = _categories.firstWhere(
      (c) => c['name'] == _selectedCategory,
      orElse: () => _categories.first,
    );

    AppState.instance.addProduct(
      name: name,
      description: description,
      price: price,
      category: _selectedCategory,
      icon: activeCat['icon'] as IconData,
      color: activeCat['color'] as Color,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.checkmark_alt,
                color: Color(0xFF34C759),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '¡Producto "$name" registrado exitosamente!',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCat = _categories.firstWhere(
      (c) => c['name'] == _selectedCategory,
      orElse: () => _categories.first,
    );

    final previewName = _nameController.text.trim().isEmpty
        ? 'Nombre del producto'
        : _nameController.text.trim();
    final previewPrice = _priceController.text.trim().isEmpty
        ? '0.00'
        : _priceController.text.trim();
    final previewDesc = _descriptionController.text.trim().isEmpty
        ? 'Aquí se visualizará la descripción de tu producto en tiempo real.'
        : _descriptionController.text.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.chevron_left, color: Color(0xFF007AFF)),
              Text(
                'Menú',
                style: TextStyle(
                  color: Color(0xFF007AFF),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 90,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título superior
              const Text(
                'REGISTRAR\nPRODUCTOS',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Completa los campos para agregar un nuevo ítem',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 18),

              // 1. Tarjeta de Vista Previa en Vivo (Live Preview Card)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (activeCat['color'] as Color).withAlpha(30),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: (activeCat['color'] as Color).withAlpha(60),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(6),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: activeCat['color'] as Color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'VISTA PREVIA EN VIVO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'S/ $previewPrice',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: activeCat['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (activeCat['color'] as Color).withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            activeCat['icon'] as IconData,
                            color: activeCat['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                previewName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                previewDesc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Formulario en Tarjeta Agrupada
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categoría
                      const Text(
                        'Categoría',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6E6E73),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory == cat['name'];
                          final catColor = cat['color'] as Color;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat['name'] as String),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? catColor.withAlpha(30) : const Color(0xFFF2F2F7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? catColor : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    cat['icon'] as IconData,
                                    size: 16,
                                    color: isSelected ? catColor : Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat['name'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? catColor : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      // Campo: Nombre del producto
                      const Text(
                        'Nombre del producto',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6E6E73),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Ej. MacBook Air M2',
                          prefixIcon: const Icon(
                            CupertinoIcons.cube_box,
                            color: Color(0xFF007AFF),
                            size: 20,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9F9FB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF007AFF),
                              width: 1.8,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa el nombre del producto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Campo: Descripción
                      const Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6E6E73),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Describe especificaciones o características clave...',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 40),
                            child: Icon(
                              CupertinoIcons.text_alignleft,
                              color: Color(0xFF007AFF),
                              size: 20,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9F9FB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF007AFF),
                              width: 1.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Campo: Precio
                      const Text(
                        'Precio',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6E6E73),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixIcon: Container(
                            width: 44,
                            alignment: Alignment.center,
                            child: const Text(
                              'S/',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF007AFF),
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9F9FB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF007AFF),
                              width: 1.8,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa el precio del producto';
                          }
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Ingresa un valor numérico válido mayor a 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Botón GUARDAR con micro-escala
                      GestureDetector(
                        onTapDown: (_) => setState(() => _isButtonPressed = true),
                        onTapUp: (_) => setState(() => _isButtonPressed = false),
                        onTapCancel: () => setState(() => _isButtonPressed = false),
                        child: AnimatedScale(
                          scale: _isButtonPressed ? 0.97 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProduct,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007AFF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isSaving
                                  ? const CupertinoActivityIndicator(
                                      color: Colors.white,
                                      radius: 12,
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.cloud_upload_fill, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'GUARDAR',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
