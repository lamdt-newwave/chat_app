import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class AudioMessage extends StatefulWidget {
  const AudioMessage({
    Key? key,
    required this.isOwnMessage,
    required this.message,
  }) : super(key: key);
  final MessageEntity message;
  final bool isOwnMessage;

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  final player = AudioPlayer();
  Duration duration = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    player.playbackEventStream.listen((event) {
      if (mounted) setState(() {});
    });
    duration = await player.setUrl(widget.message.mediaUrl) ?? Duration.zero;
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: widget.isOwnMessage ? AppColors.branchDarkMode : AppColors.branchLight),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8.w,
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (isPlaying) {
                  player.stop();
                } else {
                  player.play();
                }
                isPlaying = !isPlaying;
              });
            },
            child: isPlaying
                ? Icon(
                    Icons.stop,
                    size: 24.r,
                    color: widget.isOwnMessage
                        ? AppColors.neutralWhite
                        : AppColors.neutralActive,
                  )
                : AppAssets.svgs.icPlay.svg(
                    height: 24.h,
                    width: 24.w,
                    color: widget.isOwnMessage
                        ? AppColors.neutralWhite
                        : AppColors.neutralActive),
          ),
          SizedBox(
            width: 4.w,
          ),
          Text(
            "${duration.inMinutes}:${duration.inSeconds % 60}",
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 10.r,
                fontFamily: FontFamily.mulish,
                height: 16 / 10,
                fontWeight: FontWeight.w400,
                color: widget.isOwnMessage
                    ? AppColors.neutralWhite
                    : AppColors.neutralActive),
          ),
          SizedBox(
            width: 4.w,
          ),
          AppAssets.lotties.lottieAudioMessage.lottie(
              height: 32.h, width: MediaQuery.of(context).size.width * 0.3),
          SizedBox(
            width: 4.w,
          ),
        ],
      ),
    );
  }
}
