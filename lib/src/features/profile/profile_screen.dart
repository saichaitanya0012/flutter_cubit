import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/auth/sign_in/sign_in_screen.dart';
import 'package:goli_soda/src/features/auth/widget/custom_textfield.dart';
import 'package:goli_soda/src/features/blocked_user/blocked_user_view.dart';
import 'package:goli_soda/src/features/profile/cubit/profile_cubit.dart';
import 'package:goli_soda/src/local_storage/hive_store.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _resetPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Profile'),
      ),
      body: BlocProvider(
        create: (context) => ProfileCubit(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileInitial) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(14.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 50);
                          if (pickedFile != null) {
                            context
                                .read<ProfileCubit>()
                                .uploadImageToFirebaseStorage(File(pickedFile.path));
                          } else {
                            CustomSnackBar().errorSnackBar(message: 'No image selected.');
                            // return null;
                          }
                        },
                        child: Stack(
                          children: [
                            (HiveStore().get(Keys.imageUrl).toString().isNotEmpty)
                                ? CachedNetworkImage(
                                    imageUrl: HiveStore().get(Keys.imageUrl),
                                    placeholder: (context, url) => CircleAvatar(
                                        radius: 40.sp,
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => CircleAvatar(
                                        radius: 40.sp, child: Icon(Icons.error)),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 40.sp,
                                      backgroundImage: imageProvider,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 40.sp,
                                    backgroundImage: AssetImage('assets/images/logo.png'),
                                  ),
                            Positioned(
                              child: CircleAvatar(child: Icon(Icons.camera_alt)),
                              bottom: 0,
                              right: 0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.sp),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: Text(
                              HiveStore().get(Keys.userName),
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.sp),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('Blocked Shops',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                )),
                            onTap: () {
                              nextScreen(context, BlockedUsers());
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.sp),
                            child: Divider(
                              color: AppColors.lightColor,
                            ),
                          ),ListTile(
                            title: Text('Reset Password',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                )),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.primaryColor,
                                    title: Text('Reset Password',
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    content: CustomTextFormField(
                                      labelText: 'Enter your email',
                                      controller: _resetPasswordController,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Reset'),
                                        onPressed: () async {
                                          try {
                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                    email: _resetPasswordController.text
                                                        .trim());
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Password reset link sent to your email.')));
                                          } catch (error) {
                                            print('Error resetting password: $error');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Error resetting password. Please try again.')));
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.sp),
                            child: Divider(
                              color: AppColors.lightColor,
                            ),
                          ),
                          ListTile(
                            title: Text('Logout',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                )),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: AppColors.primaryColor,
                                    title: Text('Are you sure?',
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    content: Text('Log Out',
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Log Out'),
                                        onPressed: () async {
                                          HiveStore().clear();
                                          CustomSnackBar()
                                              .snackbarSuccess(message: "Logged Out");
                                          nextScreenCloseOthers(context, SignInScreen());
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProfileFailed) {
              return Center(child: Text(state.message));
            }
            return Center();
          },
        ),
      ),
    );
  }
}
