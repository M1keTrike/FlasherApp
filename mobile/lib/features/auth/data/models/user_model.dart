import '../../domain/entities/user.dart';

/// Modelo de datos de User: sabe (de)serializar JSON.
///
/// Extiende la entidad de dominio para que las capas superiores trabajen con
/// `User` sin conocer el detalle de transporte.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
