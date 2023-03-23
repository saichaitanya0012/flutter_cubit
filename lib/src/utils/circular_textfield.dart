import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CircularTextField extends StatelessWidget {
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? hintText;
  final String? lablelText;
  final TextInputType? textInputType;
  final FormFieldValidator<String>? validator;
  final FormFieldValidator<String>? onChange;

  const CircularTextField({
    Key? key,
    this.fieldKey,
    this.controller,
    this.hintText,
    this.lablelText,
    this.validator,
    this.onChange,
    this.textInputType=TextInputType.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 12.sp),
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          labelText: lablelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color:Colors.green,
              width: 0
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                color:Colors.green,
                width: 0
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                color:Colors.green,
                width: 0
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
        ),
        validator: validator,
        onChanged: onChange,
      ),
    );
  }
}
