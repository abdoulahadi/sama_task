class User {
  final int id;
  String nom;
  String prenom;
  String? email;
  String username;
  final String? photo;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    this.email,
    required this.username,
    this.photo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        nom: json['nom'],
        prenom: json['prenom'],
        email: json['email'],
        username: json['username'],
        photo: json['photo'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
      );
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class RegisterRequest {
  final String nom;
  final String prenom;
  final String username;
  final String password;
  final String email;
  final String photo;

  RegisterRequest({
    required this.nom,
    required this.prenom,
    required this.username,
    required this.password,
    required this.email,
    required this.photo,
  });

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'prenom': prenom,
        'username': username,
        'password': password,
        'email': email,
        'photo': photo,
      };
}

class UpdateUserRequest {
  final String nom;
  final String prenom;
  final String username;
  final String? email;
  final String? photo;

  UpdateUserRequest({
    required this.nom,
    required this.prenom,
    required this.username,
    this.email,
    this.photo,
  });

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'prenom': prenom,
        'username': username,
        'email': email,
        'photo': photo,
      };
}
