import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/ui/widgets/commons/app_dialogs.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoMessage extends StatefulWidget {
  const VideoMessage({
    Key? key,
    required this.message,
    required this.isOwnMessage,
  }) : super(key: key);

  final MessageEntity message;
  final bool isOwnMessage;

  @override
  State<VideoMessage> createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  late final VideoPlayerController videoPlayerController;
  late final ChewieController chewieController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          AppDialogs.showLoadingDialog();
          try {
            final videoPlayerController =
                VideoPlayerController.network(widget.message.mediaUrl);

            await videoPlayerController.initialize();
            final chewieController = ChewieController(
                videoPlayerController: videoPlayerController,
                autoPlay: true,
                looping: false,
                showControls: true,
                showControlsOnInitialize: true,
                showOptions: true);
            Get.back();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VideoScreen(controller: chewieController)));
          } catch (e) {
            Get.back();
          }
        },
        child: AppAssets.lotties.lottieVideoMessage.lottie());
  }
}

class VideoScreen extends StatelessWidget {
  final ChewieController controller;

  const VideoScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: Center(child: Chewie(controller: controller))));
  }
}
