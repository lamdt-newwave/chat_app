import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFailure extends StatelessWidget {
  const AppFailure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAssets.lotties.lottieAppFailure.lottie(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.6),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: 200.w,
          child: Text(
            "Something's wrong!!. Please try again later",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontFamily: FontFamily.lato),
          ),
        ),
      ],
    ));
  }
}
