import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final void Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  CustomFormField({required this.label, required this.controller, required this.validator,this.onChanged ,this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4.sp),
            child: Text(
              label,
              style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 4.sp,
            ),
            width: 70.sp,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   color: Colors.white,
            //   boxShadow: [
            //     BoxShadow(
            //       color: AppColors.whiteColor.withOpacity(0.2),
            //       blurRadius: 2,
            //       spreadRadius: 0,
            //       offset: Offset(0, 0),
            //     ),
            //   ],
            // ),
            child: Center(
              child: TextFormField(

                inputFormatters: inputFormatters,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 01,
                ),
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: AppColors.whiteColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: AppColors.lightColor,
                      width: 2,
                      strokeAlign: StrokeAlign.inside,
                      style: BorderStyle.solid,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: AppColors.semiBlueColor,
                      width: 2,
                      strokeAlign: StrokeAlign.inside,
                      style: BorderStyle.solid,
                    ),
                  ),
                  filled: true,
                ),
                validator: validator,
                onChanged: onChanged,
              ),
            ),
          )
        ],
      ),
    );
  }
}
