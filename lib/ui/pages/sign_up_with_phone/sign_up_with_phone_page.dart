import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/l10n.dart';
import 'package:chat_app/ui/pages/sign_up_with_phone/sign_up_with_phone_cubit.dart';
import 'package:chat_app/ui/widgets/button/normal_button.dart';
import 'package:chat_app/ui/widgets/common/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpWithPhonePage extends StatelessWidget {
  const SignUpWithPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignUpWithPhoneCubit(),
        child: const SignUpWithPhoneChildPage());
  }
}

class SignUpWithPhoneChildPage extends StatefulWidget {
  const SignUpWithPhoneChildPage({Key? key}) : super(key: key);

  @override
  State<SignUpWithPhoneChildPage> createState() =>
      _SignUpWithPhoneChildPageState();
}

class _SignUpWithPhoneChildPageState extends State<SignUpWithPhoneChildPage> {
  @override
  Widget build(BuildContext context) {
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
              child: AppAssets.svgs.icChevronLeft.svg(
                height: 24,
                width: 24,
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.neutralOffWhite,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: AppAssets.svgs.icHamburger.svg(
                                height: 24,
                                width: 24,
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
                                  "+64",
                                  style: textTheme.bodyText1?.copyWith(
                                      color: AppColors.neutralDisabled),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 36,
                        child: TextFormField(
                          style: textTheme.bodyText1
                              ?.copyWith(color: AppColors.neutralDisabled),
                          decoration: InputDecoration(
                            fillColor: AppColors.neutralOffWhite,
                            border: InputBorder.none,
                            filled: true,
                            hintText: "Phone Number",
                            hintStyle: textTheme.bodyText1
                                ?.copyWith(color: AppColors.neutralDisabled),
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  NormalButton(
                      onPressed: () {},
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
}
