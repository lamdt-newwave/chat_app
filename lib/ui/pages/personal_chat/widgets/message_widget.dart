import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/message_type.dart';
import 'package:chat_app/ui/pages/personal_chat/widgets/audio_message.dart';
import 'package:chat_app/ui/pages/personal_chat/widgets/file_message.dart';
import 'package:chat_app/ui/pages/personal_chat/widgets/image_message.dart';
import 'package:chat_app/ui/pages/personal_chat/widgets/video_message.dart';
import 'package:chat_app/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {Key? key,
      required this.isOwnMessage,
      required this.message,
      required this.textTheme,
      required this.isGroupMessages,
      required this.onReplyMessage,
      required this.chatUser,
      this.repliedMessage})
      : super(key: key);
  final UserEntity chatUser;
  final bool isGroupMessages;
  final bool isOwnMessage;
  final MessageEntity message;
  final MessageEntity? repliedMessage;
  final TextTheme textTheme;
  final Function(String) onReplyMessage;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SwipeTo(
      onLeftSwipe:
          isOwnMessage ? null : () => onReplyMessage(message.messageId),
      onRightSwipe:
          isOwnMessage ? null : () => onReplyMessage(message.messageId),
      child: Row(
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            margin: EdgeInsets.only(
                top: isGroupMessages ? 4.h : 10.h, left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              color: isOwnMessage &&
                      message.type != MessageType.image.toString() &&
                      message.type != MessageType.file.toString() &&
                      message.type != MessageType.video.toString()
                  ? AppColors.branchDefault
                  : AppColors.neutralWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
                bottomLeft: isOwnMessage ? Radius.circular(12.r) : Radius.zero,
                bottomRight: isOwnMessage ? Radius.zero : Radius.circular(12.r),
              ),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Column(
              crossAxisAlignment: isOwnMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                message.repliedMessageId.isNotEmpty
                    ? Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.neutralDisabled),
                        padding: EdgeInsets.all(8.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOwnMessage
                                  ? "${chatUser.firstName} ${chatUser.lastName}"
                                  : "You",
                              style: textTheme.bodyText2?.copyWith(
                                  height: 24 / 14,
                                  color: isOwnMessage
                                      ? AppColors.neutralWhite
                                      : AppColors.branchDefault),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            _buildMessageContent(repliedMessage!, context),
                          ],
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 4.h,
                ),
                _buildMessageContent(message, context),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  DateTimeUtil.timeStampToHoursMinutes(message.createdTime),
                  style: TextStyle(
                      fontSize: 10.r,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.lato,
                      fontStyle: FontStyle.normal,
                      height: 16 / 10,
                      color: isOwnMessage &&
                              message.type != MessageType.image.toString() &&
                              message.type != MessageType.file.toString() &&
                              message.type != MessageType.video.toString()
                          ? AppColors.neutralWhite
                          : AppColors.neutralDisabled),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageContent(MessageEntity message, BuildContext context) {
    if (message.type == MessageType.text.toString()) {
      return _buildTextMessage(message, context);
    } else if (message.type == MessageType.image.toString()) {
      return ImageMessage(message: message);
    } else if (message.type == MessageType.audio.toString()) {
      return AudioMessage(
        isOwnMessage: isOwnMessage,
        message: message,
      );
    } else if (message.type == MessageType.video.toString()) {
      return VideoMessage(isOwnMessage: isOwnMessage, message: message);
    } else if (message.type == MessageType.file.toString()) {
      return FileMessage(message: message, isOwnMessage: isOwnMessage);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildTextMessage(MessageEntity message, BuildContext context) {
    return Text(
      message.text,
      style: textTheme.bodyText2?.copyWith(
          color:
              isOwnMessage ? AppColors.neutralWhite : AppColors.neutralActive,
          height: 24 / 14),
    );
  }
}
