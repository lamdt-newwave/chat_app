part of 'sign_up_with_phone_cubit.dart';

class SignUpWithPhoneState extends Equatable {
  final Country selectedCountry;
  final String phoneNumber;
  final bool isVerifying;

  SignUpWithPhoneState(
      {this.isVerifying = false,
        this.phoneNumber = "/",
        Country? selectedCountry})
      : selectedCountry = selectedCountry ??
      Country.fromMap({
        "name": "Vietnam",
        "isoCode": "VN",
        "iso3Code": "VNM",
        "phoneCode": "84"
      });

  String get errorTextPhoneNumber {
    {
      if (phoneNumber.isEmpty) {
        return "Please enter phone number.";
      }
      if (phoneNumber == "/") {
        return "";
      }
      return GetUtils.isNumericOnly(phoneNumber)
          ? ""
          : "Phone number is invalid!";
    }
  }

  @override
  List<Object> get props => [selectedCountry, phoneNumber,isVerifying];

  SignUpWithPhoneState copyWith({
    Country? selectedCountry,
    String? phoneNumber,
    bool? isVerifying,
  }) {
    return SignUpWithPhoneState(
        isVerifying: isVerifying ?? this.isVerifying,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        phoneNumber: phoneNumber ?? this.phoneNumber);
  }



}


