


import 'package:auth_app/features/auth/domain/entities/user.dart';

abstract class AuthDataSource {

  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fulName);
  Future<User> checkAuthStatus(String token);

}