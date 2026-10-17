import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'list_products_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

/// [MenuScreen] - Pantalla de MENÚ principal según el diagrama de arquitectura.
/// Contiene las 4 opciones requeridas:
/// 1. Registrar productos
/// 2. Listar productos
/// 3. Perfil
/// 4. Logout
/// Diseñada con estética nativa de iOS (tarjetas agrupadas, íconos con fondos redondeados,
/// chevrons de navegación y transiciones Cupertino fluidas).
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  /// Muestra el cuadro de diálogo de confirmación estilo iOS (CupertinoAlertDialog)
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
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // Fondo agrupado gris iOS
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              // Cabecera estilo iOS con saludo y título
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PANEL PRINCIPAL',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Título exacto del diagrama: "MENÚ"
                      const Text(
                        'MENÚ',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // Avatar miniatura interactivo
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF007AFF).withAlpha(60),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'JP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // Tarjeta agrupada con las 3 opciones de navegación principales
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Opción 1: Registrar productos
                    _buildMenuItem(
                      context: context,
                      title: 'Registrar productos',
                      subtitle: 'Agregar nuevos artículos al catálogo',
                      icon: CupertinoIcons.plus_square_fill,
                      iconColor: const Color(0xFF007AFF),
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
                      padding: EdgeInsets.only(left: 68),
                      child: Divider(height: 1, thickness: 0.8),
                    ),

                    // Opción 2: Listar productos
                    _buildMenuItem(
                      context: context,
                      title: 'Listar productos',
                      subtitle: 'Ver catálogo completo y precios en S/',
                      icon: CupertinoIcons.list_bullet_indent,
                      iconColor: const Color(0xFF34C759),
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
                      padding: EdgeInsets.only(left: 68),
                      child: Divider(height: 1, thickness: 0.8),
                    ),

                    // Opción 3: Perfil
                    _buildMenuItem(
                      context: context,
                      title: 'Perfil',
                      subtitle: 'Ver y editar tus datos de usuario',
                      icon: CupertinoIcons.person_crop_circle_fill,
                      iconColor: const Color(0xFF5856D6),
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

              const SizedBox(height: 24),

              // Opción 4: Logout (tarjeta independiente estilo acción destructiva iOS)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _buildMenuItem(
                  context: context,
                  title: 'Logout',
                  subtitle: 'Cerrar sesión actual',
                  icon: CupertinoIcons.square_arrow_left_fill,
                  iconColor: const Color(0xFFFF3B30),
                  isDestructive: true,
                  onTap: () => _showLogoutConfirmation(context),
                ),
              ),

              const SizedBox(height: 40),

              // Pie informativo de versión del laboratorio
              Center(
                child: Column(
                  children: [
                    Text(
                      'Laboratorio 08 • Flutter iOS Edition',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Diseño y desarrollo avanzado para móviles',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye cada fila del menú con estética Grouped TableView de iOS
  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: iconColor.withAlpha(20),
        highlightColor: iconColor.withAlpha(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Contenedor de ícono cuadrado con esquinas redondeadas estilo iOS
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),

              // Textos de título y subtítulo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

              // Chevron de navegación iOS
              Icon(
                CupertinoIcons.chevron_forward,
                color: isDestructive
                    ? const Color(0xFFFF3B30).withAlpha(150)
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
