import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/auth/sign_up/sign_up_cubit.dart';
import 'package:goli_soda/src/features/auth/widget/custom_textfield.dart';
import 'package:goli_soda/src/features/navigator.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  SignUpCubit? signUpCubit;

  @override
  void initState() {
    signUpCubit = BlocProvider.of<SignUpCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: BlocConsumer<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                nextScreenCloseOthers(context, NavigationScreen());
              } else if (state is SignUpFailed) {
                CustomSnackBar().errorSnackBar(message: state.message);
              }
            },
            builder: (context, state) {
              if (state is SignUpLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40.sp,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomTextFormField(
                        labelText: "Email",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) => _emailController.text = value!.trim(),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      CustomTextFormField(
                        labelText: "Password",
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) => _passwordController.text = value!.trim(),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),

                      CustomTextFormField(
                        labelText: "Confirm Password",
                        controller: _confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) => _confirmPasswordController.text = value!.trim(),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 32.0),


                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            signUpCubit!.signUpWithEmailPassword(
                                _emailController.text, _passwordController.text);
                            // Call a method to sign up the user with Firebase Auth
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 30.sp,
                          decoration: BoxDecoration(
                            color: AppColors.blueColor,
                            borderRadius: BorderRadius.circular(100.sp),
                          ),
                          child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
