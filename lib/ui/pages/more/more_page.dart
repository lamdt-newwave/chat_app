import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/common/app_gradients.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/ui/pages/more/more_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit(),
      child: const MoreChildPage(),
    );
  }
}

class MoreChildPage extends StatefulWidget {
  const MoreChildPage({Key? key}) : super(key: key);

  @override
  State<MoreChildPage> createState() => _MoreChildPageState();
}

class _MoreChildPageState extends State<MoreChildPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 14,
              ),
              Text(
                "More",
                style: textTheme.subtitle1?.copyWith(height: 30 / 18),
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.neutralOffWhite),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: BlocBuilder<AppCubit, AppState>(
                            builder: (context, state) {
                              return state.user != null
                                  ? CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.neutralSafe,
                                                gradient: AppGradients.style1),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                              child: Image(
                                                height: 90.w,
                                                width: 90.w,
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) => AppAssets
                                          .lotties.lottieAppLoading
                                          .lottie(),
                                      imageUrl: state.user!.avatarUrl)
                                  : SizedBox(
                                      width: 56.w,
                                      height: 56.h,
                                      child: AppAssets.svgs.icUser
                                          .svg(fit: BoxFit.cover),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${state.user?.firstName ?? "Error"} ${state.user?.lastName ?? ""}",
                            style:
                                textTheme.bodyText1?.copyWith(height: 24 / 12),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "+${state.user?.phoneCode ?? "Error"} ${state.user?.phoneNumber ?? "Error"}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: FontFamily.mulish,
                                fontSize: 12,
                                height: 20 / 12),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.branchDefault,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  context.read<AppCubit>().signOut();
                  Get.offNamed(AppRoutes.signUpWithPhone);
                },
                child: Center(
                    child: Text(
                  "Sign Out",
                  style: textTheme.bodyText1
                      ?.copyWith(color: AppColors.neutralWhite),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
