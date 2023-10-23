import 'package:auth_app/features/auth/domain/datasources/auth_datasource.dart';
import 'package:auth_app/features/auth/domain/entities/user.dart';
import 'package:auth_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:auth_app/features/auth/infrastructure/datasources/auth_datasource_imple.dart';

class AuthRepositoryImple extends AuthRepository {

  final AuthDataSource authDataSource;

  AuthRepositoryImple({AuthDataSource? authDataSource})
      : authDataSource = authDataSource ?? AuthDatasourceImple();

  @override
  Future<User> checkAuthStatus(String token) {
    final user = authDataSource.checkAuthStatus(token);
    return user;
  }

  @override
  Future<User> login(String email, String password) {
    final user = authDataSource.login(email, password);
    return user;
  }

  @override
  Future<User> register(String email, String password, String fulName) {
    final user = authDataSource.register(email, password, fulName);
    return user;
  }
}
