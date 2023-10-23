


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/features/auth/domain/entities/user.dart';
import 'package:auth_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:auth_app/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:auth_app/features/auth/infrastructure/repositories/auth_repository_imple.dart';
import 'package:auth_app/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:auth_app/features/shared/infrastructure/services/key_value_storage_service_imple.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.errorMessage = '',
    this.user
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage?? this.errorMessage
  );

}


class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;

  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository, 
    required this.keyValueStorageService
  }): super(AuthState()){
    checkAuthStatus();
  }


  Future<void> loginUser({required String email,required String password}) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
        final User user = await authRepository.login(email, password);  
        _setLogUser(user);

    } on CustomError catch(e) {
        logout(e.message);
    } catch (e){
        logout('Algo salió mal');
    }

  }
  void registerUser(String email, String password) async {

    throw UnimplementedError();

  }
  void checkAuthStatus() async {
    final token = await keyValueStorageService.getKeyValue<String>('token');

    if(token == null) return logout();

    try {
      final User user = await authRepository.checkAuthStatus(token);  
      _setLogUser(user);
    } on CustomError catch(e) {
        logout(e.message);
    } catch (e){
        logout('Algo salió mal');
    }
    

  }


  void _setLogUser(User user)async{
    
    await keyValueStorageService.setKeyValue('toke', user.token);

    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user,
      errorMessage: ''

    );

  }

  Future<void> logout([String? errorMessage]) async{
    await keyValueStorageService.removeKey('toke');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage

    );
  }
  
}


final authProvider = StateNotifierProvider<AuthNotifier,AuthState>((ref) {
  
  final AuthRepository authRepository = AuthRepositoryImple();

  final KeyValueStorageService keyValueStorageService = KeyValueStorageServiceImple();

  return AuthNotifier(authRepository:authRepository, keyValueStorageService:keyValueStorageService);
});