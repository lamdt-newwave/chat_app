import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTextFormField extends StatelessWidget {
  const SearchTextFormField({
    Key? key,
    required this.onChanged,
    required this.onCloseSearch,
    required this.controller,
    required this.hintText,
  }) : super(key: key);
  final Function(String) onChanged;
  final Function() onCloseSearch;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 36.h,
      child: TextFormField(
        style: textTheme.bodyText1?.copyWith(color: AppColors.neutralActive),
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: onCloseSearch,
            child: controller.text.isNotEmpty
                ? AppAssets.svgs.icCloseSmall.svg(
                    width: 24.w, height: 24.h, color: AppColors.neutralDisabled)
                : const SizedBox(),
          ),
          contentPadding: EdgeInsets.only(left: 8.w, top: 6.h, bottom: 6.h),
          hintText: "Search",
          hintStyle:
              textTheme.bodyText1?.copyWith(color: AppColors.neutralDisabled),
          prefixIcon: AppAssets.svgs.icSearch
              .svg(width: 24.w, height: 24.h, color: AppColors.neutralDisabled),
          fillColor: AppColors.neutralOffWhite,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.r),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
        ),
      ),
    );
  }
}
