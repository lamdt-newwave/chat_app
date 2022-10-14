import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/l10n.dart';
import 'package:chat_app/ui/widgets/button/normal_button.dart';
import 'package:chat_app/ui/widgets/commons/wrapper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AppAssets.images.imgOnBoarding.image(
                  height: 270,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrapper(
                  height: 90,
                  child: Text(
                    I10n.current.text_on_boarding,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline2,
                  ),
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              Wrapper(
                height: 24,
                child: Text(
                  I10n.current.text_policy,
                  style: theme.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              NormalButton(
                onPressed: () {},
                child: Text(
                  I10n.current.button_start_messaging,
                  style: theme.textTheme.bodyText2
                      ?.copyWith(color: AppColors.neutralOffWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
