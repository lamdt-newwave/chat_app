import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static ThemeData get light => ThemeData(
        fontFamily: FontFamily.mulish,
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: AppColors.neutralActive,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: AppColors.neutralActive,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            color: AppColors.neutralActive,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          subtitle2: TextStyle(
            color: AppColors.neutralActive,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          bodyText1: TextStyle(
            color: AppColors.neutralActive,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: AppColors.neutralActive,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      );

  static ThemeData get dark => ThemeData();
}
