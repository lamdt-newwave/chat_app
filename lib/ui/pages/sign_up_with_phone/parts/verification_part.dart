part of '../sign_up_with_phone_page.dart';

extension BuildVerificationPage on _SignUpWithPhoneChildPageState {
  Widget _buildVerificationPage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 14.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: Get.back,
                child: AppAssets.svgs.icChevronLeft.svg(
                  height: 24.h,
                  width: 24.h,
                ),
              ),
            ),
            SizedBox(
              height: 100.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Wrapper(
                    height: 30.h,
                    child: Text(
                      I10n.current.text_enter_code,
                      style: textTheme.headline2,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  BlocBuilder<SignUpWithPhoneCubit, SignUpWithPhoneState>(
                    bloc: _cubit,
                    builder: (context, state) {
                      return SizedBox(
                        width: 270.h,
                        child: Text(
                          I10n.current.text_sent_sms(
                              "+${state.selectedCountry.phoneCode} ${state.phoneNumber}"),
                          style: textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 48.h,
                  ),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50.h,
                      fieldWidth: 40.w,
                      activeFillColor: Colors.white,
                      inactiveFillColor: AppColors.neutralWhite,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: AppColors.neutralWhite,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: TextEditingController(),
                    onCompleted: _cubit.onSignIn,
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  SizedBox(
                    height: 52.h,
                    child: TextButton(
                      onPressed: _cubit.onResendCode,
                      child: Text(
                        "Resend Code",
                        style: textTheme.subtitle2
                            ?.copyWith(color: AppColors.branchDefault),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
