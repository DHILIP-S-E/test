import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._dio, this._storage);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login/access-token',
        data: {
          'username': email,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final token = response.data['access_token'];
      await _storage.write(key: 'access_token', value: token);

      // For now, return a dummy user as we don't have a /me endpoint yet in this example
      return User(id: '1', email: email, name: 'User');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<User> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'full_name': 'New User', // Placeholder
        },
      );

      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }
}
