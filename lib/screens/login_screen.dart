import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'menu_screen.dart';

/// [LoginScreen] - Login con un "muro de inventario" animado de fondo: filas
/// de fichas con íconos de producto que se desplazan en diagonal, y una hoja
/// inferior con el formulario ([CupertinoTextField] + [CupertinoButton.filled]).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'juan@email.com');
  final _passwordController = TextEditingController(text: '123456');
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => const MenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Íconos claros en la barra de estado: el fondo es oscuro.
      value: SystemUiOverlayStyle.light,
      child: CupertinoPageScaffold(
        backgroundColor: _InventoryWall.background,
        child: Stack(
          children: [
            // 1. Muro animado de fichas
            const Positioned.fill(child: _InventoryWall()),

            // 2. Velo oscuro para que el título se lea sobre las fichas
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x330A0A1A), Color(0xF20A0A1A)],
                    stops: [0.0, 0.62],
                  ),
                ),
              ),
            ),

            // 3. Título + hoja inferior con el formulario
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  // Entrada: la hoja sube desde abajo.
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, t, child) => Opacity(
                      opacity: t,
                      child: Transform.translate(
                        offset: Offset(0, 80 * (1 - t)),
                        child: child,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(28, 0, 28, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 48,
                                  height: 1.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.5,
                                  color: CupertinoColors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Bienvenido a tu inventario digital',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xCCFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Hoja con el formulario
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            28,
                            24,
                            24 + bottomInset,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBackground
                                .resolveFrom(context),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _LoginField(
                                  label: 'Correo',
                                  icon: CupertinoIcons.mail,
                                  controller: _emailController,
                                  placeholder: 'correo@ejemplo.com',
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  onSubmitted: (_) =>
                                      _passwordFocus.requestFocus(),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Por favor ingresa tu correo';
                                    }
                                    if (!val.contains('@')) {
                                      return 'Ingresa un formato de correo válido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _LoginField(
                                  label: 'Password',
                                  icon: CupertinoIcons.lock_shield,
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  placeholder: 'Tu contraseña',
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  onSubmitted: (_) => _handleLogin(),
                                  suffix: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size.square(32),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                    child: Icon(
                                      _obscurePassword
                                          ? CupertinoIcons.eye_slash
                                          : CupertinoIcons.eye,
                                      size: 20,
                                      color: secondary,
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Ingresa tu contraseña';
                                    }
                                    if (val.length < 4) {
                                      return 'Mínimo 4 caracteres requeridos';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 54,
                                  child: CupertinoButton.filled(
                                    padding: EdgeInsets.zero,
                                    borderRadius: BorderRadius.circular(16),
                                    onPressed: _handleLogin,
                                    child: _isLoading
                                        ? const CupertinoActivityIndicator(
                                            color: CupertinoColors.white,
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'INGRESAR',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(
                                                CupertinoIcons.arrow_right,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}

/// Fondo del login: filas de fichas de colores con íconos de producto,
/// inclinadas y desplazándose sin fin en sentidos alternos.
class _InventoryWall extends StatefulWidget {
  const _InventoryWall();

  static const background = Color(0xFF0A0A1A);

  @override
  State<_InventoryWall> createState() => _InventoryWallState();
}

class _InventoryWallState extends State<_InventoryWall>
    with SingleTickerProviderStateMixin {
  static const _tile = 76.0;
  static const _gap = 14.0;
  static const _step = _tile + _gap;
  static const _rows = 16;
  static const _repeats = 5;

  // El muro es más grande que cualquier pantalla para que, al inclinarlo,
  // no se vean los bordes.
  static const _wallWidth = 2400.0;
  static const _wallHeight = _rows * _step;

  static const _icons = [
    CupertinoIcons.device_laptop,
    CupertinoIcons.cart_fill,
    CupertinoIcons.keyboard,
    CupertinoIcons.barcode,
    CupertinoIcons.tv,
    CupertinoIcons.bag_fill,
    CupertinoIcons.camera_fill,
    CupertinoIcons.cube_box_fill,
  ];

  static const _colors = [
    CupertinoColors.systemBlue,
    CupertinoColors.systemIndigo,
    CupertinoColors.systemPurple,
    CupertinoColors.systemPink,
    CupertinoColors.systemOrange,
    CupertinoColors.systemYellow,
    CupertinoColors.systemGreen,
    CupertinoColors.systemTeal,
  ];

  /// Ancho de un ciclo completo de fichas: al avanzar esto, la fila se ve
  /// igual que al inicio y el bucle no tiene corte.
  static const _patternWidth = 8 * _step;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRow(int row) {
    final tiles = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _icons.length * _repeats; i++)
          Container(
            width: _tile,
            height: _tile,
            margin: const EdgeInsets.only(right: _gap),
            decoration: BoxDecoration(
              // Cada fila arranca en un color e ícono distinto.
              color: _colors[(i + row * 3) % _colors.length],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _icons[(i + row * 5) % _icons.length],
              color: CupertinoColors.white,
              size: 36,
            ),
          ),
      ],
    );

    final movesLeft = row.isEven;

    return SizedBox(
      width: _wallWidth,
      height: _step,
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        minWidth: 0,
        maxWidth: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          // Las fichas se construyen una sola vez; por cuadro solo cambia
          // el desplazamiento.
          child: tiles,
          builder: (context, child) {
            final shift = _controller.value * _patternWidth;
            final dx = movesLeft ? -shift : shift - _patternWidth;
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRect(
        child: OverflowBox(
          minWidth: _wallWidth,
          maxWidth: _wallWidth,
          minHeight: _wallHeight,
          maxHeight: _wallHeight,
          child: Transform.rotate(
            angle: -12 * math.pi / 180,
            child: Column(
              children: [for (var row = 0; row < _rows; row++) _buildRow(row)],
            ),
          ),
        ),
      ),
    );
  }
}

/// Campo del login: etiqueta arriba, [CupertinoTextField] relleno con ícono y
/// mensaje de error debajo. Se integra con [Form] mediante [FormField].
class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.placeholder,
    required this.validator,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.suffix,
  });

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String placeholder;
  final FormFieldValidator<String> validator;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final fill = CupertinoColors.tertiarySystemFill.resolveFrom(context);
    const errorColor = CupertinoColors.destructiveRed;

    return FormField<String>(
      initialValue: controller.text,
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: secondary,
              ),
            ),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: controller,
              focusNode: focusNode,
              placeholder: placeholder,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              autofillHints: autofillHints,
              autocorrect: false,
              onChanged: field.didChange,
              onSubmitted: onSubmitted,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              prefix: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(icon, size: 20, color: theme.primaryColor),
              ),
              suffix: suffix,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(12),
                border: field.hasError ? Border.all(color: errorColor) : null,
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 2),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(fontSize: 13, color: errorColor),
                ),
              ),
          ],
        );
      },
    );
  }
}
