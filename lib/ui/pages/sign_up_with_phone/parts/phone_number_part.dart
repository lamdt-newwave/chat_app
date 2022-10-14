part of '../sign_up_with_phone_page.dart';

extension BuildPhoneNumberPage on _SignUpWithPhoneChildPageState {
  Scaffold _buildPhonePage(BuildContext context) {
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
                      I10n.current.text_enter_phone,
                      style: textTheme.headline2,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Wrapper(
                    height: 48,
                    child: Text(
                      I10n.current.text_please_confirm_country,
                      style: textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  _buildPhoneTextField(textTheme),
                  const SizedBox(
                    height: 80,
                  ),
                  NormalButton(
                      onPressed: _cubit.onMoveToVerification,
                      child: Text(
                        I10n.current.button_continue,
                        style: textTheme.subtitle2
                            ?.copyWith(color: AppColors.neutralOffWhite),
                      ))
                ],
              ),
            ),
          ],
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
              onValuePicked: _cubit.onSelectedCountryChanged),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.neutralOffWhite,
              borderRadius: BorderRadius.circular(4),
            ),
            child: BlocBuilder<SignUpWithPhoneCubit, SignUpWithPhoneState>(
              bloc: _cubit,
              builder: (context, state) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        CountryPickerUtils.getFlagImageAssetPath(
                            state.selectedCountry.isoCode),
                        height: 24.0,
                        width: 24.0,
                        fit: BoxFit.cover,
                        package: "country_pickers",
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SizedBox(
                        height: 24,
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
                height: 36,
                child: TextFormField(
                  onChanged: _cubit.onPhoneNumberChanged,
                  cursorHeight: 24,
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
                bloc: _cubit,
                builder: (context, state) {
                  return SizedBox(
                    height: 24,
                    child: state.errorTextPhoneNumber.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
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
