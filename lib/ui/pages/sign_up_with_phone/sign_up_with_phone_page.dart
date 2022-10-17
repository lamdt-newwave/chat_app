import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/ui/pages/sign_up_with_phone/sign_up_with_phone_cubit.dart';
import 'package:chat_app/ui/pages/sign_up_with_phone/widgets/enter_phone_page.dart';
import 'package:chat_app/ui/pages/sign_up_with_phone/widgets/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpWithPhonePage extends StatelessWidget {
  const SignUpWithPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return SignUpWithPhoneCubit(
              userRepository: RepositoryProvider.of<UserRepository>(context),
              authRepository: RepositoryProvider.of<AuthRepository>(context));
        },
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
            ? VerificationPage(
                cubit: _cubit,
              )
            : EnterPhonePage(
                cubit: _cubit,
              );
      },
    );
  }
}
