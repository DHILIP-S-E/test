import 'package:dio/dio.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<User> login(String email, String password) async {
    try {
      await _dio.post(
        '/auth/login/access-token',
        data: {
          'username': email,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      // final token = response.data['access_token'];
      // TODO: Save token to secure storage

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
}
