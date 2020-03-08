import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource {
  Future<bool> saveUserId(String id);
  Future<bool> saveUserType(String userType);
}

class AuthLocalDataSourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<bool> saveUserId(String id) {
    try {
      return sharedPreferences.setString(Keys.CACHED_USER_ID, id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> saveUserType(String userType) {
    try {
      return sharedPreferences.setString(Keys.CACHED_USER_TYPE, userType);
    } catch (e) {
      throw CacheException();
    }
  }
}
