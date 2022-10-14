part of '../sign_up_with_phone_page.dart';

extension BuildVerificationPage on _SignUpWithPhoneChildPageState {
  Widget _buildVerificationPage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: Get.back,
                child: AppAssets.svgs.icChevronLeft.svg(
                  height: 24,
                  width: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Wrapper(
                    height: 30,
                    child: Text(
                      I10n.current.text_enter_code,
                      style: textTheme.headline2,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BlocBuilder<SignUpWithPhoneCubit, SignUpWithPhoneState>(
                    bloc: _cubit,
                    builder: (context, state) {
                      return SizedBox(
                        width: 270,
                        child: Text(
                          I10n.current.text_sent_sms(
                              "+${state.selectedCountry.phoneCode} ${state.phoneNumber}"),
                          style: textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: AppColors.neutralWhite,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: AppColors.neutralWhite,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: TextEditingController(),
                    onCompleted: (v) {},
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  SizedBox(
                    height: 52,
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
