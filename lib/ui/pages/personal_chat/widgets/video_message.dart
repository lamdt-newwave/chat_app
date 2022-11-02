import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    videoPlayerController =
        VideoPlayerController.network(widget.message.mediaUrl);
    videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    await videoPlayerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.neutralWhite,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                        minWidth: MediaQuery.of(context).size.width * 0.3,
                      ),
                      child: Stack(
                        children: [
                          Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            placeholder: (context, url) => Center(
                  child: AppAssets.lotties.lottieLoadingDotsMessage.lottie(),
                ),
            imageUrl: widget.message.thumbnailUrl),
        SizedBox(
          height: 4.h,
        ),
        InkWell(
          onTap: () {
            final ChewieController chewieController = ChewieController(
                videoPlayerController: videoPlayerController,
                autoPlay: true,
                looping: false,
                showControls: true,
                showControlsOnInitialize: true,
                showOptions: true);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VideoScreen(controller: chewieController)));
          },
          child: Container(
            width: 30.w,
            height: 30.h,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.branchDefault),
            child: AppAssets.svgs.icPlay
                .svg(width: 24.w, height: 24.h, color: AppColors.neutralWhite),
          ),
        ),
      ],
    );
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
