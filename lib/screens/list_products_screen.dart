import 'package:flutter/cupertino.dart';
import '../models/product.dart';
import '../services/app_state.dart';
import '../widgets/ios_widgets.dart';
import 'add_product_screen.dart';

/// [ListProductsScreen] - Catálogo con título grande, búsqueda
/// ([CupertinoSearchTextField]), filtro por categoría
/// ([CupertinoSlidingSegmentedControl]) y lista agrupada con deslizar para
/// eliminar.
class ListProductsScreen extends StatefulWidget {
  const ListProductsScreen({super.key});

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  static const _all = 'Todos';
  static const _categories = [_all, 'Computadoras', 'Accesorios', 'Pantallas'];

  final _searchController = TextEditingController();
  String _query = '';
  String _category = _all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query != _query) setState(() => _query = query);
  }

  void _openAddProduct() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const AddProductScreen()),
    );
  }

  void _showProductDetails(Product product) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => _ProductDetailSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return CupertinoPageScaffold(
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final filtered = appState.products.where((p) {
            final matchesQuery = p.name.toLowerCase().contains(_query);
            final matchesCategory = _category == _all || p.category == _category;
            return matchesQuery && matchesCategory;
          }).toList();

          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Listar productos'),
                previousPageTitle: 'Menú',
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _openAddProduct,
                  child: const Icon(CupertinoIcons.plus),
                ),
              ),

              // Búsqueda + filtro por categoría
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CupertinoSearchTextField(
                        controller: _searchController,
                        placeholder: 'Buscar por nombre',
                      ),
                      const SizedBox(height: 12),
                      CupertinoSlidingSegmentedControl<String>(
                        groupValue: _category,
                        children: {
                          for (final category in _categories)
                            category: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  category,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                        },
                        onValueChanged: (value) {
                          if (value != null) setState(() => _category = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              if (filtered.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverSafeArea(
                  top: false,
                  sliver: SliverToBoxAdapter(
                    child: CupertinoListSection.insetGrouped(
                      header: SectionHeader(
                        filtered.length == 1
                            ? '1 artículo'
                            : '${filtered.length} artículos',
                      ),
                      children: [
                        for (final product in filtered)
                          Dismissible(
                            key: ValueKey(product.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: CupertinoColors.destructiveRed,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                CupertinoIcons.trash,
                                color: CupertinoColors.white,
                              ),
                            ),
                            onDismissed: (_) =>
                                appState.removeProduct(product.id),
                            child: CupertinoListTile.notched(
                              // Fondo opaco para que el rojo de "eliminar"
                              // no se vea a través de la fila al deslizar.
                              backgroundColor: CupertinoColors
                                  .secondarySystemGroupedBackground,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              leadingSize: 52,
                              leadingToTitle: 14,
                              leading: ProductImage(
                                imageUrl: product.imageUrl,
                                icon: product.icon,
                                color: product.color,
                                width: 52,
                                height: 52,
                              ),
                              title: Text(product.name),
                              subtitle: Text(product.category),
                              additionalInfo: Text(product.priceLabel),
                              trailing: const CupertinoListTileChevron(),
                              onTap: () => _showProductDetails(product),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.cube_box,
            size: 54,
            color: CupertinoColors.tertiaryLabel.resolveFrom(context),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sin resultados',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'No se encontraron artículos',
            style: TextStyle(fontSize: 15, color: secondary),
          ),
        ],
      ),
    );
  }
}

/// Ficha del producto sobre un [CupertinoPopupSurface].
class _ProductDetailSheet extends StatelessWidget {
  const _ProductDetailSheet({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separator = CupertinoColors.separator.resolveFrom(context);

    Widget infoRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text(value, style: TextStyle(color: secondary)),
          ],
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: CupertinoPopupSurface(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Foto grande del producto
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ProductImage(
                      imageUrl: product.imageUrl,
                      icon: product.icon,
                      color: product.color,
                      borderRadius: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    style: TextStyle(fontSize: 15, color: secondary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 15, height: 1.35),
                  ),
                  const SizedBox(height: 8),
                  infoRow('Precio de venta', product.priceLabel),
                  Container(height: 0.5, color: separator),
                  infoRow('Disponibilidad', 'En stock'),
                  const SizedBox(height: 8),
                  CupertinoButton.filled(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Entendido'),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      AppState.instance.removeProduct(product.id);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Eliminar producto',
                      style: TextStyle(color: CupertinoColors.destructiveRed),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
