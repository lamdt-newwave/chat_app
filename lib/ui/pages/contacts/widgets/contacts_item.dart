import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/app_gradients.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsItem extends StatelessWidget {
  const ContactsItem({
    Key? key,
    required this.user,
    required this.onPressed,
    required this.isOnline,
    required this.offLineWithinDay,
  }) : super(key: key);
  final UserEntity user;
  final Function() onPressed;
  final bool isOnline;
  final bool offLineWithinDay;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 56.h,
                    width: 56.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: isOnline || !offLineWithinDay
                          ? null
                          : AppGradients.style1,
                    ),
                    padding: EdgeInsets.all(2.r),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.neutralWhite,
                      ),
                      padding: EdgeInsets.all(2.r),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              AppAssets.lotties.lottieAppLoading.lottie(),
                          fit: BoxFit.cover,
                          imageUrl: user.avatarUrl,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isOnline || offLineWithinDay,
                    child: Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 14.w,
                        height: 14.h,
                        padding: EdgeInsets.all(2.r),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neutralWhite,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: offLineWithinDay
                                ? AppColors.branchDefault
                                : AppColors.neutralSuccess,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.h,
                    child: Text(
                      "${user.firstName} ${user.lastName}",
                      style: textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                    child: Text(
                      isOnline
                          ? "Online"
                          : DateTimeUtil.calculateLastTimeToString(
                              user.lastTime),
                      style: TextStyle(
                          fontSize: 12.r,
                          fontWeight: FontWeight.w400,
                          fontFamily: FontFamily.mulish,
                          color: AppColors.neutralDisabled),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          const Divider(
            color: AppColors.neutralLine,
            height: 1,
          ),
        ],
      ),
    );
  }
}
