import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const uIdKey = 'uid';

  late final SharedPreferences _instance;

  SharedPreferences get instance => _instance;

  void init() async {
    _instance = await SharedPreferences.getInstance();
  }
}

SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
