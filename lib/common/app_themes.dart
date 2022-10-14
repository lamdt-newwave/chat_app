import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes {
  AppThemes._();

  static ThemeData get light => ThemeData(
        fontFamily: FontFamily.mulish,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: AppColors.neutralActive,
            fontSize: 32.r,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: AppColors.neutralActive,
            fontSize: 24.r,
            fontWeight: FontWeight.bold,
          ),
          subtitle1: TextStyle(
            color: AppColors.neutralActive,
            fontWeight: FontWeight.w600,
            fontSize: 18.r,
          ),
          subtitle2: TextStyle(
            color: AppColors.neutralActive,
            fontWeight: FontWeight.w600,
            fontSize: 16.r,
          ),
          bodyText1: TextStyle(
            color: AppColors.neutralActive,
            fontWeight: FontWeight.w600,
            fontSize: 16.r,
          ),
          bodyText2: TextStyle(
            color: AppColors.neutralActive,
            fontWeight: FontWeight.normal,
            fontSize: 14.r,
          ),
        ),
      );

  static ThemeData get dark => ThemeData();
}
