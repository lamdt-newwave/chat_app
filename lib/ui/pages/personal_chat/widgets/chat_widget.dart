import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/message_type.dart';
import 'package:chat_app/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatWidget extends StatelessWidget {
  final List<MessageEntity> messages;
  final Function(String) onSend;
  final UserEntity author;
  final TextEditingController controller = TextEditingController();
  final Function() onAttachFile;

  ChatWidget({
    Key? key,
    required this.messages,
    required this.onSend,
    required this.author,
    required this.onAttachFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildChatBody(context), _buildInput(context)],
    );
  }

  Widget _buildInput(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      alignment: Alignment.center,
      height: 64.h,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.12),
      decoration: const BoxDecoration(
        color: AppColors.neutralWhite,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            InkWell(
              onTap: onAttachFile,
              child: AppAssets.svgs.icPlus.svg(
                  width: 24.w, height: 24.h, color: AppColors.neutralDisabled),
            ),
            SizedBox(
              width: 12.w,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: TextFormField(
                  controller: controller,
                  style: textTheme.bodyText1,
                  onFieldSubmitted: onSend,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 8.w,
                    ),
                    fillColor: AppColors.neutralOffWhite,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            InkWell(
              onTap: () {
                if (controller.text.isNotEmpty) {
                  onSend(controller.text);
                  controller.clear();
                  hideKeyboard(context);
                }
              },
              child: AppAssets.svgs.icSendAltFilled.svg(
                  width: 24.w,
                  height: 24.h,
                  color: controller.text.isNotEmpty
                      ? AppColors.branchDefault
                      : AppColors.neutralDisabled),
            ),
          ],
        ),
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Widget _buildChatBody(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: ListView.builder(
        physics: const ScrollPhysics(),
        itemCount: messages.length,
        shrinkWrap: true,
        reverse: true,
        itemBuilder: (_, index) {
          final message = messages[index];
          final bool isOwnMessage = author.uId == message.authorId;
          return MessageWidget(
            isOwnMessage: isOwnMessage,
            message: message,
            textTheme: textTheme,
            isGroupMessages: index > 0
                ? (messages[index - 1].authorId == messages[index].authorId)
                : true,
          );
        },
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.isOwnMessage,
    required this.message,
    required this.textTheme,
    required this.isGroupMessages,
  }) : super(key: key);
  final bool isGroupMessages;
  final bool isOwnMessage;
  final MessageEntity message;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          margin: EdgeInsets.only(
              top: isGroupMessages ? 4.h : 10.h, left: 12.w, right: 12.w),
          decoration: BoxDecoration(
            color:
                isOwnMessage ? AppColors.branchDefault : AppColors.neutralWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              bottomLeft: isOwnMessage ? Radius.circular(12.r) : Radius.zero,
              bottomRight: isOwnMessage ? Radius.zero : Radius.circular(12.r),
            ),
          ),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMessageContent(context),
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
                    color: isOwnMessage
                        ? AppColors.neutralWhite
                        : AppColors.neutralDisabled),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTextMessage(BuildContext context) {
    return Text(
      message.text,
      style: textTheme.bodyText2?.copyWith(
          color:
              isOwnMessage ? AppColors.neutralWhite : AppColors.neutralActive,
          height: 24 / 14),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    if (message.type == MessageType.text.toString()) {
      return _buildTextMessage(context);
    } else if (message.type == MessageType.image.toString()) {
      return _buildImageMessage(context);
    } else if (message.type == MessageType.file.toString()) {
      return InkWell(
        onTap: () async {},
        child: Container(
          margin: EdgeInsets.only(
              top: isGroupMessages ? 4.h : 10.h, left: 12.w, right: 12.w),
          height: MediaQuery.of(context).size.width * 0.4,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: AppAssets.lotties.lottieFileMessage.lottie(),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildImageMessage(BuildContext context) {
    return CachedNetworkImage(
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: AppColors.neutralSuccess,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                  ),
                  child: Image(
                    height: 200.h,
                    width: 200.w,
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        placeholder: (context, url) =>
            AppAssets.lotties.lottieAppLoading.lottie(),
        imageUrl: message.mediaUrl);
  }
}
