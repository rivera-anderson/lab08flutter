import 'package:flutter/cupertino.dart';
import '../services/app_state.dart';
import '../widgets/ios_widgets.dart';
import 'add_product_screen.dart';
import 'list_products_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

/// [MenuScreen] - Menú central con título grande ([CupertinoSliverNavigationBar])
/// y opciones en listas agrupadas ([CupertinoListSection.insetGrouped]).
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
  }

  void _showLogoutConfirmation(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Estás seguro de que deseas salir de tu cuenta?'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return CupertinoPageScaffold(
      child: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final user = appState.userProfile;
          final productCount = appState.products.length;

          return CustomScrollView(
            slivers: [
              const CupertinoSliverNavigationBar(
                largeTitle: Text('Menú'),
                automaticallyImplyLeading: false,
              ),
              SliverSafeArea(
                top: false,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // 1. Tarjeta de usuario estilo Apple ID
                    CupertinoListSection.insetGrouped(
                      children: [
                        CupertinoListTile(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leadingSize: 56,
                          leadingToTitle: 14,
                          leading: InitialsAvatar(initials: user.initials),
                          title: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(user.email),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => _push(context, const ProfileScreen()),
                        ),
                      ],
                    ),

                    // 2. Opciones de navegación
                    CupertinoListSection.insetGrouped(
                      header: const SectionHeader('Inventario'),
                      children: [
                        CupertinoListTile.notched(
                          leading: const IconBadge(
                            icon: CupertinoIcons.plus,
                            color: CupertinoColors.systemBlue,
                          ),
                          title: const Text('Registrar productos'),
                          subtitle: const Text('Agregar al inventario'),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => _push(context, const AddProductScreen()),
                        ),
                        CupertinoListTile.notched(
                          leading: const IconBadge(
                            icon: CupertinoIcons.list_bullet_below_rectangle,
                            color: CupertinoColors.systemGreen,
                          ),
                          title: const Text('Listar productos'),
                          subtitle: const Text('Catálogo y precios en S/'),
                          additionalInfo: Text('$productCount'),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () =>
                              _push(context, const ListProductsScreen()),
                        ),
                      ],
                    ),

                    CupertinoListSection.insetGrouped(
                      header: const SectionHeader('Cuenta'),
                      children: [
                        CupertinoListTile.notched(
                          leading: const IconBadge(
                            icon: CupertinoIcons.person_fill,
                            color: CupertinoColors.systemIndigo,
                          ),
                          title: const Text('Perfil'),
                          subtitle: const Text('Información de la cuenta'),
                          trailing: const CupertinoListTileChevron(),
                          onTap: () => _push(context, const ProfileScreen()),
                        ),
                        CupertinoListTile.notched(
                          leading: const IconBadge(
                            icon: CupertinoIcons.square_arrow_left_fill,
                            color: CupertinoColors.systemRed,
                          ),
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                          subtitle: const Text('Finalizar la sesión actual'),
                          onTap: () => _showLogoutConfirmation(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
