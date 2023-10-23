

import 'package:dio/dio.dart';
import 'package:auth_app/config/environment/environment.dart';
import 'package:auth_app/features/auth/domain/datasources/auth_datasource.dart';
import 'package:auth_app/features/auth/domain/entities/user.dart';
import 'package:auth_app/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:auth_app/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthDatasourceImple extends AuthDataSource{


  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl
    )
  );



  @override
  Future<User> checkAuthStatus(String token)async {
    
    try {
      final response = await dio.get('/auth/check-status', 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        )
      );

      final User user = UserMapper.userJsonToEntitie(response.data);
      return user;

    } on DioException catch(e) {

      if (e.response?.statusCode == 401){
        throw CustomError('Token no válido', 401);
      }
      if (e.type == DioExceptionType.connectionTimeout) {
         throw CustomError(e.response?.data['message'] ?? 'Revisa su conexión a internet', 401);
      }
      
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password)async {
    
    try {
      final response = await dio.post('/auth/login',data: {
        "email": email,
        "password" : password
      });
      final User user = UserMapper.userJsonToEntitie(response.data);
      return user;

    } on DioException catch(e) {

      if (e.response?.statusCode == 401){
        throw CustomError(e.response?.data['message'] ?? 'Credenciales incorrectas', 401);
      }
      if (e.type == DioExceptionType.connectionTimeout) {
         throw CustomError(e.response?.data['message'] ?? 'Revisa su conexión a internet', 401);
      }
      
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fulName) {
    
    throw UnimplementedError();
  }


}