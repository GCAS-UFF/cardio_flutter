import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final SharedPreferences sharedPreferences;

  // 1. Trocamos @required (anotação) por required (palavra-chave nativa)
  Settings({required this.sharedPreferences});

  // 2. Mudamos o retorno para String? porque o SharedPreferences 
  // retorna null se não encontrar o valor.
  String? getUserType() {
    try {
      return sharedPreferences.getString(Keys.CACHED_USER_TYPE);
    } catch (e) {
      throw CacheException();
    }
  }

  String? getUserId() {
    try {
      return sharedPreferences.getString(Keys.CACHED_USER_ID);
    } catch (e) {
      throw CacheException();
    }
  }
}