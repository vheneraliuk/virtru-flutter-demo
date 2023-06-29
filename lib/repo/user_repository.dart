import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class UserRepository {
  Future<User?> getUser() async {
    var prefs = await SharedPreferences.getInstance();
    var prefValues = prefs.getStringList('creds');
    if (prefValues == null || prefValues.length != 2) return null;
    return User(userId: prefValues.first, appId: prefValues.last);
  }

  void saveUser(User user) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList('creds', [user.userId, user.appId]);
  }
}
