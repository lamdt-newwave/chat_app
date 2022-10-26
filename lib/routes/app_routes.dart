import 'package:chat_app/ui/pages/home/home_page.dart';
import 'package:chat_app/ui/pages/personal_chat/personal_chat_page.dart';
import 'package:chat_app/ui/pages/profile_account/profile_account_page.dart';
import 'package:chat_app/ui/pages/sign_up_with_phone/sign_up_with_phone_page.dart';
import 'package:chat_app/ui/pages/splash/splash_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = "/home";
  static const String splash = "/splash";
  static const String signUpWithPhone = "/sign-up-with-phone";
  static const String profileAccount = "/profile-account";
  static const String personalChatPage = "/personal-chat-page";

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
        GetPage(
          name: profileAccount,
          page: () => const ProfileAccountPage(),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: personalChatPage,
          page: () => const PersonalChatPage(),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ];
}
