import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialogs {
  static void showCountryPicker({required Function(Country) onValuePicked}) {
    Get.dialog(CountryPickerDialog(
        titlePadding: EdgeInsets.all(8.0),
        searchCursorColor: Colors.pinkAccent,
        searchInputDecoration: InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        title: Text('Select your phone code'),
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
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );
}
