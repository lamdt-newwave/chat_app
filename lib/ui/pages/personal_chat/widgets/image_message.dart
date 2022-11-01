import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.neutralSuccess,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                  ),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        placeholder: (context, url) => Center(
              child: AppAssets.lotties.lottieLoadingDotsMessage.lottie(),
            ),
        imageUrl: message.mediaUrl);
  }
}
