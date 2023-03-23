import 'package:flutter/material.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';


class CTAButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CTAButton({super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onPressed,
              child: Container(
                // width: double.infinity,
                height: 30.sp,
                decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(100.sp),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
