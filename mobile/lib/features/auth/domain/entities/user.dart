/// Entidad de dominio: usuario autenticado.
///
/// No conoce nada de JSON ni de la capa de datos (Clean Architecture).
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;
}
