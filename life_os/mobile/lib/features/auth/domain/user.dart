import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;

  const User({required this.id, required this.email, this.name});

  @override
  List<Object?> get props => [id, email, name];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['full_name'] as String?,
    );
  }
}
