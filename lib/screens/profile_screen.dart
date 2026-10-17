import 'dart:ui' show ImageFilter;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';

/// [ProfileScreen] - Pantalla de PERFIL de usuario con estética Apple ID.
/// Muestra avatar con anillo luminoso, estadísticas de cuenta, campos agrupados
/// y un modal emergente de edición en caliente con validación.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context) {
    final appState = AppState.instance;
    final current = appState.userProfile;

    final nameController = TextEditingController(text: current.name);
    final emailController = TextEditingController(text: current.email);
    final phoneController = TextEditingController(text: current.phone);
    final formKey = GlobalKey<FormState>();

    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Editar Perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Nombre
                const Text(
                  'Nombre',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6E6E73),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.person_crop_circle, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9F9FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ingresa el nombre' : null,
                ),
                const SizedBox(height: 14),

                // Correo
                const Text(
                  'Correo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6E6E73),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.mail, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9F9FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ingresa el correo' : null,
                ),
                const SizedBox(height: 14),

                // Teléfono
                const Text(
                  'Teléfono',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6E6E73),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.phone, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9F9FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ingresa el teléfono' : null,
                ),
                const SizedBox(height: 22),

                // Botones Cancelar / Guardar
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: const Color(0xFF007AFF),
                        borderRadius: BorderRadius.circular(14),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          appState.updateProfile(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
                          );
                          Navigator.pop(ctx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                '¡Perfil actualizado con éxito!',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF34C759),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        child: const Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

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
          child: ListenableBuilder(
            listenable: appState,
            builder: (context, _) {
              final profile = appState.userProfile;
              final productCount = appState.products.length;

              final initials = profile.name.trim().isNotEmpty
                  ? profile.name
                      .trim()
                      .split(' ')
                      .map((e) => e.isNotEmpty ? e[0] : '')
                      .take(2)
                      .join()
                      .toUpperCase()
                  : 'JP';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título principal: "PERFIL"
                  const Text(
                    'PERFIL',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Información general y credenciales de usuario',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Avatar Apple ID con aura brillante
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF007AFF).withAlpha(90),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF34C759),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.checkmark_alt,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Estadísticas de la cuenta en minitarjetas
                  Row(
                    children: [
                      _buildStatPill('Productos', '$productCount', CupertinoIcons.cube_box, const Color(0xFF007AFF)),
                      const SizedBox(width: 10),
                      _buildStatPill('Rol', 'Admin', CupertinoIcons.shield_fill, const Color(0xFF5856D6)),
                      const SizedBox(width: 10),
                      _buildStatPill('Estado', 'Activo', CupertinoIcons.bolt_fill, const Color(0xFF34C759)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tarjeta agrupada con datos exactos: Nombre, Correo, Teléfono
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
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Column(
                      children: [
                        _buildProfileField(
                          label: 'Nombre',
                          value: profile.name,
                          icon: CupertinoIcons.person_fill,
                          color: const Color(0xFF007AFF),
                        ),
                        const Divider(height: 20, thickness: 0.7),
                        _buildProfileField(
                          label: 'Correo',
                          value: profile.email,
                          icon: CupertinoIcons.mail_solid,
                          color: const Color(0xFF5856D6),
                        ),
                        const Divider(height: 20, thickness: 0.7),
                        _buildProfileField(
                          label: 'Teléfono',
                          value: profile.phone,
                          icon: CupertinoIcons.phone_fill,
                          color: const Color(0xFF34C759),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Botón: EDITAR PERFIL
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => _showEditProfileDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.pencil_circle_fill, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'EDITAR PERFIL',
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
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
