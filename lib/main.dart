import 'package:chat_app/app.dart';
import 'package:chat_app/common/app_observer.dart';
import 'package:chat_app/database/share_preferences_helper.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  sharedPreferencesHelper.init();
  final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory());
  HydratedBlocOverrides.runZoned(
    () => runApp(const App()),
    storage: storage,
    blocObserver: AppObserver(),
  );
}
