import 'dart:async';

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
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

part 'parts/verification_part.dart';

part 'parts/phone_number_part.dart';

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
  late final SignUpWithPhoneCubit _cubit;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SignUpWithPhoneCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpWithPhoneCubit, SignUpWithPhoneState>(
      bloc: _cubit,
      builder: (context, state) {
        return state.isVerifying
            ? _buildVerificationPage(context)
            : _buildPhonePage(context);
      },
    );
  }
}
