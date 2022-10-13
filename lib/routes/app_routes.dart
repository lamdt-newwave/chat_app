

import 'package:chat_app/ui/pages/home/home_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static const String home = "/home";


  static List<GetPage> get pages =>
      [GetPage(name: home, page: () => const HomePage())];
}
