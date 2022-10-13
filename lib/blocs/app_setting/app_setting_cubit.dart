import 'package:bloc/bloc.dart';
import 'package:chat_app/app.dart';
import 'package:chat_app/configs/app_configs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_setting_state.dart';

class AppSettingCubit extends Cubit<AppSettingState> with HydratedMixin {
  AppSettingCubit() : super(const AppSettingState());

  void resetSetting() {
    emit(const AppSettingState());
  }

  void changeThemeMode({required ThemeMode themeMode}) {
    emit(state.copyWith(themeMode: themeMode));
  }

  void changeLocal({required Locale locale}) {
    emit(state.copyWith(locale: locale));
    Get.updateLocale(locale);
  }

  @override
  AppSettingState? fromJson(Map<String, dynamic> json) {
    return AppSettingState(
      themeMode: json['themeMode'] is int
          ? ThemeMode.values[json['themeMode']]
          : ThemeMode.system,
      locale: json['local'] is String
          ? Locale.fromSubtags(languageCode: json['local'])
          : AppConfigs.defaultLocal,
    );
  }

  @override
  Map<String, dynamic>? toJson(AppSettingState state) {
    return {
      'themeMode': state.themeMode.index,
      'local': state.locale.languageCode,
    };
  }
}
