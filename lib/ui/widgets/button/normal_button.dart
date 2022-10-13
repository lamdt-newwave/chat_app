import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final double height;
  final double width;
  final GestureTapCallback onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final Widget child;

  const NormalButton(
      {Key? key,
      this.height = 52,
      this.width = double.infinity,
      this.backgroundColor = AppColors.branchDefault,
      this.borderRadius = 32,
      required this.onPressed,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
