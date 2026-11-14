/// Modelo de datos para representar el Perfil del usuario
class UserProfile {
  String name;
  String email;
  String phone;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
  });

  /// Hasta dos iniciales del nombre, por ejemplo "JP" para "Juan Pérez".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0]).join().toUpperCase();
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
