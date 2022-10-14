part of 'sign_up_with_phone_cubit.dart';

class SignUpWithPhoneState extends Equatable {
  final Country selectedCountry;
  final String phoneNumber;
  final bool isVerifying;
  final String verificationId;

  SignUpWithPhoneState(
      {this.isVerifying = false,
      this.phoneNumber = "/",
      this.verificationId = "",
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
  List<Object> get props =>
      [selectedCountry, phoneNumber, isVerifying, verificationId];

  SignUpWithPhoneState copyWith({
    Country? selectedCountry,
    String? phoneNumber,
    bool? isVerifying,
    String? verificationId,
  }) {
    return SignUpWithPhoneState(
        verificationId: verificationId ?? this.verificationId,
        isVerifying: isVerifying ?? this.isVerifying,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        phoneNumber: phoneNumber ?? this.phoneNumber);
  }
}
