import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/message_type.dart';
import 'package:chat_app/ui/pages/personal_chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatWidget extends StatelessWidget {
  final List<MessageEntity> messages;
  final Function(String) onSend;
  final UserEntity author;
  final TextEditingController controller = TextEditingController();
  final Function() onAttachFile;
  final Function(String) onReplyMessage;
  final String replyingMessageId;
  final UserEntity chatUser;

  ChatWidget({
    Key? key,
    required this.messages,
    required this.onSend,
    required this.author,
    required this.onAttachFile,
    required this.onReplyMessage,
    required this.replyingMessageId,
    required this.chatUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChatBody(context),
        SizedBox(
          height: 12.h,
        ),
        replyingMessageId.isNotEmpty
            ? _buildRepliedMessage(context)
            : const SizedBox(),
        _buildInput(context)
      ],
    );
  }

  Widget _buildRepliedMessage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final replyingMessage = messages
        .firstWhere((element) => element.messageId == replyingMessageId);
    return Container(
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
          color: AppColors.neutralWeak.withOpacity(0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Replying to ${chatUser.firstName} ${chatUser.lastName}",
            style: textTheme.subtitle1,
          ),
          SizedBox(
            height: 4.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: _buildRepliedContentMessage(context, replyingMessage),
          )
        ],
      ),
    );
  }

  Widget _buildRepliedContentMessage(
      BuildContext context, MessageEntity replyingMessage) {
    final textTheme = Theme.of(context).textTheme;
    if (replyingMessage.type == MessageType.text.toString()) {
      return Text(replyingMessage.text);
    } else if (replyingMessage.type == MessageType.image.toString()) {
      return Text(
        "Image",
        style: textTheme.bodyText2,
      );
    } else if (replyingMessage.type == MessageType.video.toString()) {
      return Text("Video", style: textTheme.bodyText2);
    } else if (replyingMessage.type == MessageType.audio.toString()) {
      return Text("Audio", style: textTheme.bodyText2);
    } else {
      return Text("File", style: textTheme.bodyText2);
    }
  }

  Widget _buildInput(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      alignment: Alignment.center,
      height: 64.h,
      constraints: BoxConstraints(
          minHeight: 64.h, maxHeight: MediaQuery.of(context).size.height * 0.3),
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
                  maxLines: 10,
                  controller: controller,
                  style: textTheme.bodyText1,
                  onFieldSubmitted: onSend,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 8.w, top: 8.h, right: 8.w),
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
            chatUser: chatUser,
            isOwnMessage: isOwnMessage,
            message: message,
            textTheme: textTheme,
            isGroupMessages: index > 0
                ? (messages[index - 1].authorId == messages[index].authorId)
                : true,
            onReplyMessage: onReplyMessage,
            repliedMessage: messages.firstWhereOrNull(
                (element) => element.messageId == message.repliedMessageId),
          );
        },
      ),
    );
  }
}
