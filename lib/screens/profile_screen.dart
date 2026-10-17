import 'dart:ui' show ImageFilter;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';

/// [ProfileScreen] - Pantalla de PERFIL con estética KROMA.
/// Avatar circular de alto contraste, tarjetas de estadísticas y edición modal oscura.
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
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            top: 24,
            left: 20,
            right: 20,
          ),
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF202227),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withAlpha(20),
              width: 1,
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: 18),
                const Text(
                  'EDITAR PERFIL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Campo Nombre
                const Text(
                  'Nombre',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9EA3AE),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.person, color: Color(0xFFFF6548), size: 20),
                    filled: true,
                    fillColor: const Color(0xFF141518),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ingresa el nombre' : null,
                ),
                const SizedBox(height: 14),

                // Campo Correo
                const Text(
                  'Correo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9EA3AE),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.mail, color: Color(0xFFFF6548), size: 20),
                    filled: true,
                    fillColor: const Color(0xFF141518),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ingresa el correo' : null,
                ),
                const SizedBox(height: 14),

                // Campo Teléfono
                const Text(
                  'Teléfono',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9EA3AE),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.phone, color: Color(0xFFFF6548), size: 20),
                    filled: true,
                    fillColor: const Color(0xFF141518),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Ingresa el teléfono' : null,
                ),
                const SizedBox(height: 24),

                // Botones Cancelar / Guardar
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: const Color(0xFF141518),
                        borderRadius: BorderRadius.circular(25),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: const Color(0xFFFF6548),
                        borderRadius: BorderRadius.circular(25),
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
                                '¡Perfil KROMA actualizado!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF202227),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        child: const Text(
                          'Guardar',
                          style: TextStyle(
                            color: Color(0xFF141518),
                            fontWeight: FontWeight.w900,
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
      backgroundColor: const Color(0xFF141518),
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior con botón circular (←)
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
                    'PERFIL',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Contenido de Perfil
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        const SizedBox(height: 10),

                        // Avatar circular de alto impacto visual (como en la referencia)
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF6548),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      color: Color(0xFF141518),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF5CD8A6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.checkmark_alt,
                                    color: Color(0xFF141518),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        Text(
                          profile.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'KROMA Administrator • Full Access',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9EA3AE),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Métricas en minitarjetas
                        Row(
                          children: [
                            _buildStatCard('Artículos', '$productCount', const Color(0xFF6B7AFF)),
                            const SizedBox(width: 10),
                            _buildStatCard('Nivel', 'Admin', const Color(0xFFFF6548)),
                            const SizedBox(width: 10),
                            _buildStatCard('Estado', 'Activo', const Color(0xFF5CD8A6)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Tarjeta agrupada con datos requeridos: Nombre, Correo, Teléfono
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: const Color(0xFF202227),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withAlpha(15),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildFieldRow(
                                label: 'Nombre',
                                value: profile.name,
                                icon: CupertinoIcons.person_fill,
                                color: const Color(0xFFFF6548),
                              ),
                              const Divider(height: 24, thickness: 0.8, color: Color(0xFF2E313A)),
                              _buildFieldRow(
                                label: 'Correo',
                                value: profile.email,
                                icon: CupertinoIcons.mail_solid,
                                color: const Color(0xFF6B7AFF),
                              ),
                              const Divider(height: 24, thickness: 0.8, color: Color(0xFF2E313A)),
                              _buildFieldRow(
                                label: 'Teléfono',
                                value: profile.phone,
                                icon: CupertinoIcons.phone_fill,
                                color: const Color(0xFF5CD8A6),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Botón: EDITAR PERFIL en Coral vibrante
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => _showEditProfileDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6548),
                              foregroundColor: const Color(0xFF141518),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.pencil, size: 20, color: Color(0xFF141518)),
                                SizedBox(width: 8),
                                Text(
                                  'EDITAR PERFIL',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF202227),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withAlpha(12),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9EA3AE),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(14),
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
                  color: Color(0xFF9EA3AE),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
