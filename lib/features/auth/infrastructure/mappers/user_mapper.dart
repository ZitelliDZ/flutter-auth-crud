



import 'package:auth_app/features/auth/domain/entities/user.dart';

class UserMapper {


  static User userJsonToEntitie(Map<String,dynamic> json){

    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      token: json['token'] ?? '',
      roles: List<String>.from(json['roles'].map((role) => role))
    );
  }
}