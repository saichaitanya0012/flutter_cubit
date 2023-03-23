import 'package:flutter/material.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchField({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 14.sp),
      child: TextField(
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.secondaryColor,
          hintText: "Search",
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 0,
              strokeAlign: StrokeAlign.inside,
              style: BorderStyle.solid,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.sp),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 0,
              strokeAlign: StrokeAlign.inside,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
