import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chewie/chewie.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  static Future<void> showCountryPicker(
      {required Function(Country) onValuePicked}) {
    return Get.dialog(CountryPickerDialog(
        titlePadding: const EdgeInsets.all(8.0),
        searchCursorColor: Colors.pinkAccent,
        searchInputDecoration: const InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        title: const Text('Select your phone code'),
        onValuePicked: onValuePicked,
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('VN'),
          CountryPickerUtils.getCountryByIsoCode('US'),
        ],
        itemBuilder: _buildDialogItem));
  }

  static Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          const SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  static Future<void> showLoadingDialog() {
    return Get.dialog(
      Center(
        child: Container(
          width: Get.size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.neutralOffWhite,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Get.size.height * 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAssets.lotties.lottieAppLoading.lottie(
                  height: 160,
                  width: 160,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Wait a few seconds!",
                  style: Get.textTheme.subtitle2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  static Future<void> showErrorDialog() {
    return Get.dialog(
      Material(
        child: Center(
          child: Container(
            width: Get.size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.neutralOffWhite,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Get.size.height * 0.03),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppAssets.lotties.lottieAppLoading.lottie(
                    height: 160,
                    width: 160,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Wait a few seconds!",
                    style: Get.textTheme.subtitle2,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showVideoScreen(ChewieController controller) {
    return Get.dialog(Center(
        child: Container(
            constraints: BoxConstraints(
              maxWidth: Get.size.width * 0.8,
              maxHeight: Get.size.height * 0.6,
            ),
            child: Chewie(controller: controller))));
  }
}
