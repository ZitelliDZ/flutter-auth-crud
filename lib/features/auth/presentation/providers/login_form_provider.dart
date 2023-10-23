//!1 Estado
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:auth_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:auth_app/features/shared/infrastructure/inputs/email.dart';
import 'package:auth_app/features/shared/infrastructure/inputs/password.dart';

class LoginFormSate {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  final Email email;
  final Password password;

  LoginFormSate(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormSate copyWith(
      {bool? isPosting,
      bool? isFormPosted,
      bool? isValid,
      Email? email,
      Password? password}) {
    return LoginFormSate(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  @override
  String toString() {
    return '''
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      email: $email
      password: $password
    ''';
  }
}

//!2 Implementar notificador  StateNotifier
class LoginFormNotifier extends StateNotifier<LoginFormSate> {

  final Function({required String email, required String password}) loginUserCallback;
  LoginFormNotifier({required this.loginUserCallback}) : super(LoginFormSate());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword, isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;
    
    print(state);
    await loginUserCallback(
      email: state.email.value,
      password: state.password.value
    );
  }

  _touchEveryField(){
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state=state.copyWith(
      isFormPosted: true,
      email: email, 
      password: password,
      isValid: Formz.validate([email,password])
    );
  }
}

//!3 StateNotifierProvider
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormSate>((ref) {

  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback:loginUserCallback);
});