import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NormalTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;

  const NormalTextField({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 36.h,
      child: TextFormField(
        onChanged: onChanged,
        style: textTheme.bodyText1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 8.w, top: 6.h, bottom: 6.h),
          hintStyle:
              textTheme.bodyText1?.copyWith(color: AppColors.neutralDisabled),
          hintText: hintText,
          filled: true,
          fillColor: AppColors.neutralOffWhite,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
