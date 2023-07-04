import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtru_demo_flutter/model/model.dart';

class UserRepository {

  static const  credsKey = 'creds';

  Future<User?> getUser() async {
    var prefs = await SharedPreferences.getInstance();
    var prefValues = prefs.getStringList(credsKey);
    if (prefValues == null || prefValues.length != 2) return null;
    return User(userId: prefValues.first, appId: prefValues.last);
  }

  void saveUser(User user) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(credsKey, [user.userId, user.appId]);
  }

  void removeCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(credsKey);
  }
}
