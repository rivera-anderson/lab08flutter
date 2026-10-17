import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import 'add_product_screen.dart';
import 'list_products_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

/// [MenuScreen] - Menú principal KROMA inspirado en la estética visual neo-grotesca oscura.
/// Bloques de color audaces (Coral #FF6548, Periwinkle #6B7AFF, Canary Yellow #F7B944)
/// con botones circulares de acción, tipografía contundente y barra de navegación flotante tipo píldora.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedNavTab = 0;

  void _showLogoutConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text('¿Estás seguro de que deseas salir de tu cuenta?'),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
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

    return Scaffold(
      backgroundColor: const Color(0xFF141518),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final user = appState.userProfile;
            final productCount = appState.products.length;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Barra superior: Avatar, Saludo y Botones circulares (estilo referencia)
                        Row(
                          children: [
                            // Avatar circular con iniciales
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6548),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'JP',
                                  style: TextStyle(
                                    color: Color(0xFF141518),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hola, ${user.name.split(' ').first}!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const Text(
                                  'KROMA Central Hub',
                                  style: TextStyle(
                                    color: Color(0xFF9EA3AE),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            // Botón circular Buscar
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const ListProductsScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.search,
                                  color: Color(0xFF141518),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Pill de Ubicación / Empresa (como en la referencia "The Daily Grind, NY")
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF202227),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withAlpha(15),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.cube_box,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'KROMA Inventory • Store 01',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                CupertinoIcons.chevron_down,
                                color: Colors.white70,
                                size: 16,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Título exacto del diagrama
                        const Text(
                          'MENÚ',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --------------------------------------------------
                        // OPCIÓN 1: Registrar productos (Tarjeta Coral vibrante)
                        // --------------------------------------------------
                        _buildHeroMenuCard(
                          backgroundColor: const Color(0xFFFF6548),
                          textColor: const Color(0xFF141518),
                          badgeText: 'NUEVO ARTÍCULO',
                          badgeBg: Colors.black.withAlpha(25),
                          badgeTextColor: const Color(0xFF141518),
                          title: 'Registrar productos',
                          subtitle: 'Agrega nuevos productos con nombre, descripción y precio',
                          icon: CupertinoIcons.plus_square_fill,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const AddProductScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        // --------------------------------------------------
                        // OPCIÓN 2: Listar productos (Tarjeta Periwinkle Blue)
                        // --------------------------------------------------
                        _buildHeroMenuCard(
                          backgroundColor: const Color(0xFF6B7AFF),
                          textColor: Colors.white,
                          badgeText: '$productCount DISPONIBLES',
                          badgeBg: Colors.white.withAlpha(40),
                          badgeTextColor: Colors.white,
                          title: 'Listar productos',
                          subtitle: 'Catálogo de artículos en almacén con precios en S/',
                          icon: CupertinoIcons.list_bullet_indent,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const ListProductsScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        // --------------------------------------------------
                        // OPCIÓN 3: Perfil (Tarjeta Canary Yellow)
                        // --------------------------------------------------
                        _buildHeroMenuCard(
                          backgroundColor: const Color(0xFFF7B944),
                          textColor: const Color(0xFF141518),
                          badgeText: 'CUENTA ACTIVA',
                          badgeBg: Colors.black.withAlpha(25),
                          badgeTextColor: const Color(0xFF141518),
                          title: 'Perfil',
                          subtitle: 'Nombre, Correo, Teléfono y edición de usuario',
                          icon: CupertinoIcons.person_crop_circle_fill,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        // --------------------------------------------------
                        // OPCIÓN 4: Logout (Tarjeta Carbón Mate con botón circular)
                        // --------------------------------------------------
                        _buildHeroMenuCard(
                          backgroundColor: const Color(0xFF202227),
                          textColor: Colors.white,
                          badgeText: 'SESIÓN',
                          badgeBg: const Color(0xFFFF453A).withAlpha(40),
                          badgeTextColor: const Color(0xFFFF6548),
                          title: 'Logout',
                          subtitle: 'Cerrar la sesión de usuario activa',
                          icon: CupertinoIcons.square_arrow_left_fill,
                          isLogout: true,
                          onTap: () => _showLogoutConfirmation(context),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // 2. Barra de Navegación Flotante tipo Píldora (como en la imagen de referencia)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF202227),
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: Colors.white.withAlpha(20),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(90),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavIcon(0, CupertinoIcons.house_fill, 'Inicio', () {}),
                      _buildNavIcon(1, CupertinoIcons.plus_app, 'Registrar', () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const AddProductScreen(),
                          ),
                        );
                      }),
                      _buildNavIcon(2, CupertinoIcons.square_list, 'Listar', () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const ListProductsScreen(),
                          ),
                        );
                      }),
                      _buildNavIcon(3, CupertinoIcons.person, 'Perfil', () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavIcon(int index, IconData icon, String label, VoidCallback onTap) {
    final isSelected = _selectedNavTab == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedNavTab = index);
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6B7AFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF9EA3AE),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildHeroMenuCard({
    required Color backgroundColor,
    required Color textColor,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: backgroundColor == const Color(0xFF202227)
                  ? Colors.black.withAlpha(50)
                  : backgroundColor.withAlpha(70),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Título principal
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtítulo
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withAlpha(isLogout ? 160 : 200),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Botón circular blanco o acentuado con flecha diagonal como en la referencia (↗)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isLogout ? const Color(0xFFFF453A).withAlpha(40) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isLogout ? CupertinoIcons.square_arrow_left : CupertinoIcons.arrow_up_right,
                color: isLogout ? const Color(0xFFFF6548) : const Color(0xFF141518),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
