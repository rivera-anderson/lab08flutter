import 'package:flutter/cupertino.dart';
import '../models/product_images.dart';
import '../services/app_state.dart';
import '../widgets/ios_widgets.dart';

class _Category {
  const _Category(this.name, this.icon, this.color, this.imageUrl);

  final String name;
  final IconData icon;
  final Color color;

  /// Foto por defecto para los productos de esta categoría.
  final String imageUrl;
}

const _categories = [
  _Category(
    'Computadoras',
    CupertinoIcons.device_laptop,
    Color(0xFF007AFF),
    ProductImages.laptop,
  ),
  _Category(
    'Accesorios',
    CupertinoIcons.keyboard,
    Color(0xFF5856D6),
    ProductImages.keyboard,
  ),
  _Category(
    'Pantallas',
    CupertinoIcons.tv,
    Color(0xFF34C759),
    ProductImages.monitor,
  ),
  _Category(
    'Otros',
    CupertinoIcons.cube_box,
    Color(0xFFFF9500),
    ProductImages.box,
  ),
];

/// [AddProductScreen] - Registro de productos con formulario agrupado
/// ([CupertinoFormSection]) y vista previa que se actualiza al escribir.
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
  final _imageController = TextEditingController();

  _Category _category = _categories.first;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Refresca la vista previa mientras el usuario escribe.
    _nameController.addListener(_refresh);
    _descriptionController.addListener(_refresh);
    _priceController.addListener(_refresh);
    _imageController.addListener(_refresh);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  /// La URL que escribió el usuario o, si la dejó vacía, la foto de la
  /// categoría.
  String get _imageUrl {
    final custom = _imageController.text.trim();
    return _isValidImageUrl(custom) ? custom : _category.imageUrl;
  }

  bool _isValidImageUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// Acepta tanto "79.90" como "79,90" (el teclado decimal de iOS en español
  /// escribe coma).
  double? _parsePrice(String raw) =>
      double.tryParse(raw.trim().replaceAll(',', '.'));

  Future<void> _pickCategory() async {
    final picked = await showCupertinoModalPopup<_Category>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Categoría'),
        actions: [
          for (final category in _categories)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(ctx, category),
              child: Text(category.name),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
      ),
    );
    if (picked != null && mounted) setState(() => _category = picked);
  }

  Future<void> _saveProduct() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 700));

    final name = _nameController.text.trim();

    AppState.instance.addProduct(
      name: name,
      description: _descriptionController.text.trim(),
      price: _parsePrice(_priceController.text)!,
      category: _category.name,
      icon: _category.icon,
      color: _category.color,
      imageUrl: _imageUrl,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageController.clear();

    final done = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Producto registrado'),
        content: Text('"$name" se agregó al inventario.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Agregar otro'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Listo'),
          ),
        ],
      ),
    );

    if (done == true && mounted) Navigator.pop(context);
  }

  Widget _label(String text) => SizedBox(width: 110, child: Text(text));

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Registrar productos'),
        previousPageTitle: 'Menú',
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _PreviewCard(
                category: _category,
                imageUrl: _imageUrl,
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
                price: _priceController.text.trim(),
              ),
              const SizedBox(height: 8),

              CupertinoFormSection.insetGrouped(
                header: const SectionHeader('Datos del producto'),
                children: [
                  CupertinoTextFormFieldRow(
                    prefix: _label('Nombre'),
                    controller: _nameController,
                    placeholder: 'Ej. MacBook Air M2',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el nombre del producto';
                      }
                      return null;
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: _label('Precio (S/)'),
                    controller: _priceController,
                    placeholder: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el precio del producto';
                      }
                      final parsed = _parsePrice(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Ingresa un número mayor a 0';
                      }
                      return null;
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: _label('Descripción'),
                    controller: _descriptionController,
                    placeholder: 'Opcional',
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 4,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: _label('Imagen (URL)'),
                    controller: _imageController,
                    placeholder: 'Opcional',
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    validator: (value) {
                      final url = value?.trim() ?? '';
                      if (url.isEmpty) return null;
                      if (!_isValidImageUrl(url)) {
                        return 'Ingresa una URL completa (https://...)';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile.notched(
                    leading: IconBadge(
                      icon: _category.icon,
                      color: _category.color,
                    ),
                    title: const Text('Categoría'),
                    additionalInfo: Text(_category.name),
                    trailing: const CupertinoListTileChevron(),
                    onTap: _pickCategory,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CupertinoButton.filled(
                  onPressed: _saveProduct,
                  child: _isSaving
                      ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                        )
                      : const Text('GUARDAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tarjeta que muestra cómo se verá el producto en el catálogo.
class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.category,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
  });

  final _Category category;
  final String imageUrl;
  final String name;
  final String description;
  final String price;

  @override
  Widget build(BuildContext context) {
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground
            .resolveFrom(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ProductImage(
            imageUrl: imageUrl,
            icon: category.icon,
            color: category.color,
            width: 56,
            height: 56,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Nombre del producto' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: name.isEmpty ? secondary : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description.isEmpty ? category.name : description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: secondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'S/ ${price.isEmpty ? '0.00' : price}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}
