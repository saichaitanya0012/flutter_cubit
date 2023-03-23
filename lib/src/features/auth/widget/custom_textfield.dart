import 'package:flutter/material.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';


class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;

  const CustomTextFormField({
    Key? key,
     this.labelText,
     this.controller,
     this.keyboardType,
     this.obscureText=false,
     this.validator,
     this.onSaved,
      this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 01,
      ),
      controller: controller,
      obscureText:  obscureText!,
      decoration: InputDecoration(
        labelText: labelText,
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
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}
