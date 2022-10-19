part of 'sign_up_with_phone_cubit.dart';

class SignUpWithPhoneState extends Equatable {
  final Country selectedCountry;
  final String phoneNumber;
  final bool isVerifying;
  final String verificationId;
  final LoadStatus loadStatus;

  SignUpWithPhoneState(
      {this.loadStatus = LoadStatus.initial,
      this.isVerifying = false,
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
      return GetUtils.isPhoneNumber(phoneNumber)
          ? ""
          : "Phone number is invalid!";
    }
  }

  bool get isCorrectPhoneNumber => errorTextPhoneNumber.isEmpty;

  @override
  List<Object> get props =>
      [selectedCountry, phoneNumber, isVerifying, verificationId, loadStatus];

  SignUpWithPhoneState copyWith(
      {Country? selectedCountry,
      String? phoneNumber,
      bool? isVerifying,
      String? verificationId,
      LoadStatus? loadStatus}) {
    return SignUpWithPhoneState(
        loadStatus: loadStatus ?? this.loadStatus,
        verificationId: verificationId ?? this.verificationId,
        isVerifying: isVerifying ?? this.isVerifying,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        phoneNumber: phoneNumber ?? this.phoneNumber);
  }
}
