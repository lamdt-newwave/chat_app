import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileMessage extends StatelessWidget {
  const FileMessage(
      {Key? key, required this.message, required this.isOwnMessage})
      : super(key: key);
  final MessageEntity message;
  final bool isOwnMessage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PdfScreen(
                      url: message.mediaUrl,
                    )));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.open_in_new,
            size: 24,
            color: AppColors.branchDefault,
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            message.mediaUrl.split("/").last.split("?").first,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class PdfScreen extends StatelessWidget {
  final String url;

  const PdfScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: SfPdfViewer.network(url)));
  }
}
