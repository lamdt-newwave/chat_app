import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Alignment alignment;

  const Wrapper(
      {Key? key,
      this.width = double.infinity,
      this.height = double.infinity,
      this.alignment = Alignment.center,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      height: height,
      width: width,
      child: child,
    );
  }
}
