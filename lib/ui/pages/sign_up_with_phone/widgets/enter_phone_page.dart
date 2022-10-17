import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/l10n.dart';
import 'package:chat_app/ui/pages/sign_up_with_phone/sign_up_with_phone_cubit.dart';
import 'package:chat_app/ui/widgets/button/normal_button.dart';
import 'package:chat_app/ui/widgets/commons/app_dialogs.dart';
import 'package:chat_app/ui/widgets/commons/wrapper.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EnterPhonePage extends StatelessWidget {
  final SignUpWithPhoneCubit cubit;

  const EnterPhonePage({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                        I10n.current.text_enter_phone,
                        style: textTheme.headline2,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Wrapper(
                      height: 48.h,
                      child: Text(
                        I10n.current.text_please_confirm_country,
                        style: textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 48.h,
                    ),
                    _buildPhoneTextField(textTheme),
                    SizedBox(
                      height: 80.h,
                    ),
                    NormalButton(
                      onPressed: cubit.onMoveToVerification,
                      child: Text(
                        I10n.current.button_continue,
                        style: textTheme.subtitle2
                            ?.copyWith(color: AppColors.neutralOffWhite),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneTextField(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => AppDialogs.showCountryPicker(
              onValuePicked: cubit.onSelectedCountryChanged),
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppColors.neutralOffWhite,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: BlocBuilder<SignUpWithPhoneCubit, SignUpWithPhoneState>(
              bloc: cubit,
              builder: (context, state) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: Image.asset(
                        CountryPickerUtils.getFlagImageAssetPath(
                            state.selectedCountry.isoCode),
                        height: 24.r,
                        width: 24.r,
                        fit: BoxFit.cover,
                        package: "country_pickers",
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: SizedBox(
                        height: 24.h,
                        child: Text(
                          "+${state.selectedCountry.phoneCode}",
                          style: textTheme.bodyText1
                              ?.copyWith(color: AppColors.neutralDisabled),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 36.h,
                child: TextFormField(
                  onChanged: cubit.onPhoneNumberChanged,
                  cursorHeight: 24.h,
                  cursorColor: AppColors.neutralDisabled,
                  maxLines: 1,
                  style: textTheme.bodyText1
                      ?.copyWith(color: AppColors.neutralDisabled),
                  decoration: InputDecoration(
                    fillColor: AppColors.neutralOffWhite,
                    border: InputBorder.none,
                    filled: true,
                    hintText: I10n.current.text_phone_number,
                    hintStyle: textTheme.bodyText1?.copyWith(
                      color: AppColors.neutralDisabled,
                    ),
                  ),
                ),
              ),
              BlocBuilder<SignUpWithPhoneCubit, SignUpWithPhoneState>(
                bloc: cubit,
                builder: (context, state) {
                  return SizedBox(
                    height: 24.h,
                    child: state.errorTextPhoneNumber.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              state.errorTextPhoneNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(
                                      color: AppColors.accentDanger,
                                      fontWeight: FontWeight.w600),
                            ),
                          )
                        : null,
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
