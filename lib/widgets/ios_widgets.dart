import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Ícono blanco sobre un cuadrado de color con esquinas redondeadas,
/// como los de la app Ajustes de iOS. Pensado para el `leading` de un
/// [CupertinoListTile].
class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 30,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.23),
      ),
      child: Icon(icon, color: CupertinoColors.white, size: size * 0.6),
    );
  }
}

/// Avatar circular con las iniciales del usuario.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.initials, this.size = 56});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [CupertinoColors.systemBlue, CupertinoColors.systemIndigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: CupertinoColors.white,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Encabezado pequeño en mayúsculas para [CupertinoListSection] y
/// [CupertinoFormSection].
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
      ),
    );
  }
}

/// Foto de un producto con esquinas redondeadas. Mientras carga muestra un
/// [CupertinoActivityIndicator]; si no hay URL o falla la descarga, muestra
/// el ícono de la categoría sobre su color.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.icon,
    required this.color,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  final String? imageUrl;
  final IconData icon;
  final Color color;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    Widget fallback() {
      return ColoredBox(
        color: color,
        child: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: Icon(
              icon,
              color: CupertinoColors.white,
              size: constraints.biggest.shortestSide * 0.5,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: (url == null || url.isEmpty)
            ? fallback()
            : Image.network(
                url,
                fit: BoxFit.cover,
                // Wikimedia pide un User-Agent descriptivo. En web el
                // navegador pone el suyo y no se puede cambiar.
                headers: kIsWeb
                    ? null
                    : const {'User-Agent': 'Lab08FlutterApp/1.0 (proyecto de curso)'},
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return ColoredBox(
                    color: CupertinoColors.tertiarySystemFill.resolveFrom(
                      context,
                    ),
                    child: const Center(child: CupertinoActivityIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => fallback(),
              ),
      ),
    );
  }
}
