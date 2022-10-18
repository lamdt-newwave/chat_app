import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/app_gradients.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/ui/pages/profile_account/profile_account_cubit.dart';
import 'package:chat_app/ui/widgets/button/normal_button.dart';
import 'package:chat_app/ui/widgets/text_field/normal_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileAccountPage extends StatelessWidget {
  const ProfileAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileAccountCubit(
          userRepository: RepositoryProvider.of<UserRepository>(context),
          authRepository: RepositoryProvider.of<AuthRepository>(context)),
      child: const ProfileAccountChildPage(),
    );
  }
}

class ProfileAccountChildPage extends StatefulWidget {
  const ProfileAccountChildPage({Key? key}) : super(key: key);

  @override
  State<ProfileAccountChildPage> createState() =>
      _ProfileAccountChildPageState();
}

class _ProfileAccountChildPageState extends State<ProfileAccountChildPage> {
  late final ProfileAccountCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProfileAccountCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.r),
          child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child:
                          AppAssets.svgs.icChevronLeft.svg(fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  SizedBox(
                    height: 32.h,
                    child: Center(
                      child: Text(
                        "Your Profile",
                        style: textTheme.subtitle1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60.h,
              ),
              Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.neutralOffWhite),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child:
                          BlocBuilder<ProfileAccountCubit, ProfileAccountState>(
                        builder: (context, state) {
                          return state.avatarUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.neutralSafe,
                                            gradient: AppGradients.style1),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.w),
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
                                      ),
                                  placeholder: (context, url) => AppAssets
                                      .lotties.lottieAppLoading
                                      .lottie(),
                                  imageUrl: state.avatarUrl)
                              : SizedBox(
                                  width: 56.w,
                                  height: 56.h,
                                  child: AppAssets.svgs.icUser
                                      .svg(fit: BoxFit.cover),
                                );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: _cubit.onPickImage,
                        child: AppAssets.svgs.icPlusCircle
                            .svg(width: 24.w, height: 24.h, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              NormalTextField(
                hintText: "First Name (Required)",
                onChanged: _cubit.onFirstNameChanged,
              ),
              SizedBox(
                height: 12.h,
              ),
              NormalTextField(
                hintText: "Last Name (Optional)",
                onChanged: _cubit.onLastNameChanged,
              ),
              SizedBox(
                height: 60.h,
              ),
              BlocBuilder<ProfileAccountCubit, ProfileAccountState>(
                builder: (context, state) {
                  return NormalButton(
                    backgroundColor: state.isEnableSave
                        ? AppColors.branchDefault
                        : AppColors.neutralDisabled,
                    onPressed: _cubit.onSave,
                    child: Text(
                      "Save",
                      style: textTheme.subtitle2
                          ?.copyWith(color: AppColors.neutralOffWhite),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
