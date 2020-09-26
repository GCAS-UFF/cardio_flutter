import 'package:cardio_flutter/core/error/exception.dart';
import 'package:cardio_flutter/resources/keys.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection_container.dart' as di;

abstract class AuthLocalDataSource {
  Future<bool> saveUserId(String id);
  Future<bool> saveUserType(String userType);
  Future<String> getUserId();
  Future<String> getUserType();
  Future<void> signOut();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
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

  @override
  Future<String> getUserId() async {
    try {
      return sharedPreferences.getString(Keys.CACHED_USER_ID);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String> getUserType() async {
    try {
      return sharedPreferences.getString(Keys.CACHED_USER_TYPE);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await sharedPreferences.clear();
      di.reset();
    } catch (e) {
      throw e;
    }
  }
}
