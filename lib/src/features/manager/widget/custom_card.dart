import 'package:flutter/material.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final Function() onTap;

  const CustomCard({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.sp),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, 2.0),
              ),
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(16.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: AppColors.whiteColor, size: 14.sp),
            ],
          ),
        ),
      ),
    );
  }
}
