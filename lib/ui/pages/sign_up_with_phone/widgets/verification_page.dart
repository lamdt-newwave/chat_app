import 'dart:async';

import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/l10n.dart';
import 'package:chat_app/ui/pages/sign_up_with_phone/sign_up_with_phone_cubit.dart';
import 'package:chat_app/ui/widgets/commons/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationPage extends StatelessWidget {
  final SignUpWithPhoneCubit cubit;
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  VerificationPage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
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
                    bloc: cubit,
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
                    onCompleted: cubit.onSignIn,
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
                      onPressed: cubit.onResendCode,
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
