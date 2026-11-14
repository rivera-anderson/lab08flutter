import 'package:flutter/cupertino.dart';
import '../services/app_state.dart';
import '../widgets/ios_widgets.dart';

/// [ProfileScreen] - Perfil del usuario con listas agrupadas
/// ([CupertinoListSection.insetGrouped]) y edición en una hoja a pantalla
/// completa.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _openEditor(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const _EditProfileScreen(),
      ),
    );
  }

  /// Valor a la derecha de la fila; se recorta si es muy largo.
  Widget _value(String text) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Perfil'),
        previousPageTitle: 'Menú',
      ),
      child: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final profile = appState.userProfile;
            final productCount = appState.products.length;

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                Center(
                  child: InitialsAvatar(initials: profile.initials, size: 96),
                ),
                const SizedBox(height: 12),
                Text(
                  profile.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: secondary),
                ),
                const SizedBox(height: 12),

                CupertinoListSection.insetGrouped(
                  header: const SectionHeader('Datos personales'),
                  children: [
                    CupertinoListTile.notched(
                      leading: const IconBadge(
                        icon: CupertinoIcons.person_fill,
                        color: CupertinoColors.systemBlue,
                      ),
                      title: const Text('Nombre'),
                      additionalInfo: _value(profile.name),
                    ),
                    CupertinoListTile.notched(
                      leading: const IconBadge(
                        icon: CupertinoIcons.mail_solid,
                        color: CupertinoColors.systemIndigo,
                      ),
                      title: const Text('Correo'),
                      additionalInfo: _value(profile.email),
                    ),
                    CupertinoListTile.notched(
                      leading: const IconBadge(
                        icon: CupertinoIcons.phone_fill,
                        color: CupertinoColors.systemGreen,
                      ),
                      title: const Text('Teléfono'),
                      additionalInfo: _value(profile.phone),
                    ),
                  ],
                ),

                CupertinoListSection.insetGrouped(
                  header: const SectionHeader('Cuenta'),
                  children: [
                    CupertinoListTile.notched(
                      leading: const IconBadge(
                        icon: CupertinoIcons.cube_box,
                        color: CupertinoColors.systemOrange,
                      ),
                      title: const Text('Productos'),
                      additionalInfo: Text('$productCount'),
                    ),
                    const CupertinoListTile.notched(
                      leading: IconBadge(
                        icon: CupertinoIcons.shield_fill,
                        color: CupertinoColors.systemPurple,
                      ),
                      title: Text('Rol'),
                      additionalInfo: Text('Admin'),
                    ),
                    const CupertinoListTile.notched(
                      leading: IconBadge(
                        icon: CupertinoIcons.bolt_fill,
                        color: CupertinoColors.systemGreen,
                      ),
                      title: Text('Estado'),
                      additionalInfo: Text('Activo'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoButton.filled(
                    onPressed: () => _openEditor(context),
                    child: const Text('EDITAR PERFIL'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EditProfileScreen extends StatefulWidget {
  const _EditProfileScreen();

  @override
  State<_EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final current = AppState.instance.userProfile;
    _nameController = TextEditingController(text: current.name);
    _emailController = TextEditingController(text: current.email);
    _phoneController = TextEditingController(text: current.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    AppState.instance.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    Navigator.pop(context);
  }

  Widget _label(String text) => SizedBox(width: 92, child: Text(text));

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        middle: const Text('Editar perfil'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: const Text(
            'Guardar',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              CupertinoFormSection.insetGrouped(
                children: [
                  CupertinoTextFormFieldRow(
                    prefix: _label('Nombre'),
                    controller: _nameController,
                    placeholder: 'Nombre completo',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'Ingresa el nombre'
                        : null,
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: _label('Correo'),
                    controller: _emailController,
                    placeholder: 'correo@ejemplo.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Ingresa el correo';
                      }
                      if (!val.contains('@')) {
                        return 'Ingresa un formato de correo válido';
                      }
                      return null;
                    },
                  ),
                  CupertinoTextFormFieldRow(
                    prefix: _label('Teléfono'),
                    controller: _phoneController,
                    placeholder: '999 999 999',
                    keyboardType: TextInputType.phone,
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'Ingresa el teléfono'
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
