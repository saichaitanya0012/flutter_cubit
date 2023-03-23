import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/auth/sign_in/sign_in_cubit.dart';
import 'package:goli_soda/src/features/auth/sign_up/sign_up_screen.dart';
import 'package:goli_soda/src/features/auth/widget/custom_textfield.dart';
import 'package:goli_soda/src/features/home/home_screen.dart';
import 'package:goli_soda/src/features/navigator.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:sizer/sizer.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignInCubit? signInCubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    signInCubit = BlocProvider.of<SignInCubit>(context);
    super.initState();
  }

  // SignInCubit get signInCubit => BlocProvider.of<SignInCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            nextScreenCloseOthers(context, NavigationScreen());
          } else if (state is SignInFailed) {
            CustomSnackBar().errorSnackBar(message: state.message);
            // debugPrint(state.message);
          }
        },
        builder: (context, state) {
          if (state is SignInLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
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
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
                          TextButton(
                            onPressed: () {
                              nextScreen(context, SignUpScreen());
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(color: AppColors.blueColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            signInCubit!.loginWithEmail(
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
                            'Login',
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
              ),
            ),
          );
        },
      ),
    );
  }
}
