import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/l10n.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/ui/pages/splash/splash_cubit.dart';
import 'package:chat_app/ui/widgets/button/normal_button.dart';
import 'package:chat_app/ui/widgets/commons/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SplashCubit(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            authRepository: RepositoryProvider.of<AuthRepository>(context),
            appCubit: context.read<AppCubit>());
      },
      child: const SplashChildPage(),
    );
  }
}

class SplashChildPage extends StatefulWidget {
  const SplashChildPage({Key? key}) : super(key: key);

  @override
  State<SplashChildPage> createState() => _SplashChildPageState();
}

class _SplashChildPageState extends State<SplashChildPage> {
  late final SplashCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<SplashCubit>();
    _cubit.checkSignIn();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(
                height: 100.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AppAssets.images.imgOnBoarding.image(
                  height: 270.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrapper(
                  height: 90.h,
                  child: Text(
                    I10n.current.text_on_boarding,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline2,
                  ),
                ),
              ),
              const Spacer(),
              Wrapper(
                height: 24.h,
                child: Text(
                  I10n.current.text_policy,
                  style: theme.textTheme.bodyText1,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              NormalButton(
                onPressed: _cubit.onGoSignUpWithPhonePage,
                child: Text(
                  I10n.current.button_start_messaging,
                  style: theme.textTheme.bodyText2
                      ?.copyWith(color: AppColors.neutralOffWhite),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
