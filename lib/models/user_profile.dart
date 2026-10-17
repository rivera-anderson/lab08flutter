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
