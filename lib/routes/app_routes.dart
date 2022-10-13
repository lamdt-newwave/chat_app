import 'package:chat_app/ui/pages/home/home_page.dart';
import 'package:chat_app/ui/pages/sign_up_with_phone/sign_up_with_phone_page.dart';
import 'package:chat_app/ui/pages/splash/splash_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = "/home";
  static const String splash = "/splash";
  static const String signUpWithPhone = "/sign-up-with-phone";

  static List<GetPage> get pages => [
        GetPage(
          name: home,
          page: () => const HomePage(),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: splash,
          page: () => const SplashPage(),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: signUpWithPhone,
          page: () => const SignUpWithPhonePage(),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ];
}
