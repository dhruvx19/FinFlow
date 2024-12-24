import 'package:hive/hive.dart';

class AuthHelper {
  static const String authBoxName = 'authBox';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userEmailKey = 'userEmail';
  
  static late Box _authBox;
  
  static Future<void> init() async {
    _authBox = await Hive.openBox(authBoxName);
  }

  static Future<void> setLoggedIn(String email) async {
    await _authBox.put(isLoggedInKey, true);
    await _authBox.put(userEmailKey, email);
  }

  static Future<void> setLoggedOut() async {
    await _authBox.put(isLoggedInKey, false);
    await _authBox.put(userEmailKey, '');
  }

  static bool isLoggedIn() {
    return _authBox.get(isLoggedInKey, defaultValue: false);
  }

  static String? getUserEmail() {
    return _authBox.get(userEmailKey);
  }
}