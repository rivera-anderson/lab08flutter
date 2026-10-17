import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import 'add_product_screen.dart';
import 'list_products_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

/// [MenuScreen] - Menú central estilo iOS 18.
/// Ofrece tarjetas reactivas con retroalimentación táctil de escala,
/// contadores dinámicos sincronizados con el estado y diálogo de confirmación Cupertino.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int? _pressedIndex;

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
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListenableBuilder(
            listenable: appState,
            builder: (context, _) {
              final user = appState.userProfile;
              final productCount = appState.products.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  // 1. Tarjeta de Usuario estilo Apple ID
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(8),
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar con gradiente y borde activo
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF007AFF).withAlpha(70),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'JP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      CupertinoIcons.checkmark_seal_fill,
                                      color: Color(0xFF007AFF),
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.chevron_forward,
                            color: Color(0xFFC7C7CC),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Título MENÚ
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'MENÚ',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Selecciona una de las opciones disponibles',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Tarjetas Agrupadas de Navegación
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
                    child: Column(
                      children: [
                        // Opción 1: Registrar productos
                        _buildInteractiveMenuItem(
                          index: 0,
                          title: 'Registrar productos',
                          subtitle: 'Agregar nuevos productos al inventario',
                          icon: CupertinoIcons.plus_app_fill,
                          iconGradient: const [Color(0xFF007AFF), Color(0xFF00C7BE)],
                          badgeText: '+ Nuevo',
                          badgeColor: const Color(0xFF007AFF),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const AddProductScreen(),
                              ),
                            );
                          },
                        ),

                        const Padding(
                          padding: EdgeInsets.only(left: 72),
                          child: Divider(height: 1, thickness: 0.7),
                        ),

                        // Opción 2: Listar productos
                        _buildInteractiveMenuItem(
                          index: 1,
                          title: 'Listar productos',
                          subtitle: 'Catálogo de artículos y precios en S/',
                          icon: CupertinoIcons.list_bullet_below_rectangle,
                          iconGradient: const [Color(0xFF34C759), Color(0xFF30D158)],
                          badgeText: '$productCount items',
                          badgeColor: const Color(0xFF34C759),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const ListProductsScreen(),
                              ),
                            );
                          },
                        ),

                        const Padding(
                          padding: EdgeInsets.only(left: 72),
                          child: Divider(height: 1, thickness: 0.7),
                        ),

                        // Opción 3: Perfil
                        _buildInteractiveMenuItem(
                          index: 2,
                          title: 'Perfil',
                          subtitle: 'Gestionar información de la cuenta',
                          icon: CupertinoIcons.person_crop_circle_fill,
                          iconGradient: const [Color(0xFF5856D6), Color(0xFFAF52DE)],
                          badgeText: 'Verificado',
                          badgeColor: const Color(0xFF5856D6),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Opción 4: Logout (Tarjeta destructiva con micro-escala)
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
                    child: _buildInteractiveMenuItem(
                      index: 3,
                      title: 'Logout',
                      subtitle: 'Finalizar sesión de usuario actual',
                      icon: CupertinoIcons.square_arrow_left_fill,
                      iconGradient: const [Color(0xFFFF3B30), Color(0xFFFF453A)],
                      isDestructive: true,
                      onTap: () => _showLogoutConfirmation(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveMenuItem({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> iconGradient,
    required VoidCallback onTap,
    String? badgeText,
    Color? badgeColor,
    bool isDestructive = false,
  }) {
    final isPressed = _pressedIndex == index;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedIndex = index),
      onTapUp: (_) => setState(() => _pressedIndex = null),
      onTapCancel: () => setState(() => _pressedIndex = null),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Row(
            children: [
              // Contenedor de ícono con gradiente y esquinas curvadas
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient.first.withAlpha(60),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 23),
              ),
              const SizedBox(width: 15),

              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDestructive
                            ? const Color(0xFFFF3B30)
                            : Colors.black,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge informativo si existe
              if (badgeText != null && badgeColor != null)
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

              // Chevron de navegación iOS
              Icon(
                CupertinoIcons.chevron_forward,
                color: isDestructive
                    ? const Color(0xFFFF3B30).withAlpha(140)
                    : const Color(0xFFC7C7CC),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
