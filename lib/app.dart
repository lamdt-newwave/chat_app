import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/blocs/app_setting/app_setting_cubit.dart';
import 'package:chat_app/common/app_themes.dart';
import 'package:chat_app/configs/app_configs.dart';
import 'package:chat_app/generated/l10n.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepositoryImpl()),
        RepositoryProvider<UserRepository>(
            create: (context) => UserRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppSettingCubit(),
          ),
          BlocProvider(
            create: (context) => AppCubit(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                authRepository: RepositoryProvider.of<AuthRepository>(context)),
          ),
        ],
        child: BlocBuilder<AppSettingCubit, AppSettingState>(
          builder: (context, state) {
            return ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (BuildContext context, Widget? child) {
                return GetMaterialApp(
                  color: AppConfigs.primaryColor,
                  title: AppConfigs.appName,
                  getPages: AppRoutes.pages,
                  initialRoute: AppRoutes.splash,
                  debugShowCheckedModeBanner: true,
                  theme: AppThemes.light,
                  darkTheme: AppThemes.dark,
                  themeMode: state.themeMode,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    I10n.delegate,
                  ],
                  locale: state.locale,
                  supportedLocales: I10n.delegate.supportedLocales,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
