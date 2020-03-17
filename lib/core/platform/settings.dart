import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

class Settings {
  final SharedPreferences sharedPreferences;

  Settings({@required this.sharedPreferences});


  String getUserType() {
    try {
      return sharedPreferences.getString(Keys.CACHED_USER_TYPE);
    } catch (e) {
      throw CacheException();
    }
  }
  
}