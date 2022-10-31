import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:chat_app/models/entities/room_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/ui/pages/contacts/widgets/contacts_item.dart';
import 'package:chat_app/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({
    Key? key,
    required this.user,
    required this.room,
    required this.onPressed,
  }) : super(key: key);

  final UserEntity user;
  final RoomEntity room;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 56.h,
        margin: EdgeInsets.only(top: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarWidget(
              user: user,
              isOnline: user.status == 1,
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.h,
                    child: Text(
                      "${user.firstName} ${user.lastName}",
                      style: textTheme.bodyText1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    room.getLastMessage(),
                    style: textTheme.bodyText1?.copyWith(
                        color: AppColors.neutralDisabled,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.r,
                        fontFamily: FontFamily.mulish),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 16.h,
                  child: Text(
                    DateTimeUtil.timeStampToDayMonth(
                        room.messages.last.createdTime),
                    style: textTheme.bodyText1?.copyWith(
                        color: AppColors.neutralWeak,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.r,
                        fontFamily: FontFamily.mulish),
                  ),
                ),
                const Spacer(),
                room.getUnreadMessages() != 0
                    ? Container(
                        decoration: BoxDecoration(
                          color: AppColors.branchBackground,
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        padding: EdgeInsets.only(
                            left: 8.w, right: 8.w, top: 2.h, bottom: 2.h),
                        child: Text(
                          room.getUnreadMessages().toString(),
                          style: textTheme.bodyText1?.copyWith(
                              color: AppColors.branchDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.r,
                              fontFamily: FontFamily.mulish),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 10.h,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
