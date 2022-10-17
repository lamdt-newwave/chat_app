import 'package:chat_app/common/constants.dart';
import 'package:chat_app/database/share_preferences_helper.dart';

abstract class AuthRepository {
  void saveUid(String uid);

  void removeUid();

  String getUid();

  bool isSignedIn();

  void signOut();

}

class AuthRepositoryImpl extends AuthRepository {
  @override
  void removeUid() {
    sharedPreferencesHelper.instance.remove(SharedPreferencesHelper.uIdKey);
  }

  @override
  void saveUid(String uid) {
    sharedPreferencesHelper.instance
        .setString(SharedPreferencesHelper.uIdKey, uid);
  }

  @override
  String getUid() {
    return sharedPreferencesHelper.instance
            .getString(SharedPreferencesHelper.uIdKey) ??
        "";
  }

  @override
  bool isSignedIn() {
    return getUid().isNotEmpty;
  }

  @override
  void signOut() {
    sharedPreferencesHelper.instance.remove(SharedPreferencesHelper.uIdKey);
  }
}
