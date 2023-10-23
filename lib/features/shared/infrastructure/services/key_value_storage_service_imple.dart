

import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_app/features/shared/infrastructure/services/key_value_storage_service.dart';

class KeyValueStorageServiceImple extends KeyValueStorageService{
  

  Future getSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  

  @override
  Future<T?> getKeyValue<T>(String key) async {

    final SharedPreferences prefs = await getSharedPrefs();
    final T? value;

    switch (T) {
      case int:
        value = prefs.getInt(key) as T?;
        break;
      case String:
        value = prefs.getString(key) as T?;
        break;
      default:
        throw UnimplementedError("Set not implemented for type ${T.runtimeType}");
    }

    return value;
  }

  @override
  Future<bool> removeKey(String key) async{
    
    final SharedPreferences prefs = await getSharedPrefs();
    
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async{
    
    final SharedPreferences prefs = await getSharedPrefs();


    switch (T) {
      case int:
        await prefs.setInt(key, value as int);
        break;
      case String:
        await prefs.setString(key, value as String);
        break;
      default:
        throw UnimplementedError("Set not implemented for type ${T.runtimeType}");
    }
  }

}