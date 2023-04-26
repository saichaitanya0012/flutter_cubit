import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/all_shops/cubit/all_shop_cubit.dart';
import 'package:goli_soda/src/features/auth/widget/custom_textfield.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_cubit.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_screen.dart';
import 'package:goli_soda/src/features/get_lines/get_lines_view.dart';
import 'package:goli_soda/src/features/shop_detail/shop_detail_cubit.dart';
import 'package:goli_soda/src/features/shop_history/shop_history_screen.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ShopDetailScreen extends StatefulWidget {
  final Map<dynamic, dynamic>? shopData;

  const ShopDetailScreen({Key? key, this.shopData}) : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final TextEditingController totalCrateEditingController = TextEditingController();
  final TextEditingController totalAmountEditingController = TextEditingController();
  final TextEditingController crateReceivedEditingController = TextEditingController();

  ShopDetailCubit? shopDetailCubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    shopDetailCubit = BlocProvider.of<ShopDetailCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllShopCubit, AllShopState>(
      listener: (context, state) {
        if (state is AllShopLoaded) {
          Navigator.pop(context);
        }
      },
      builder: (context, state1) {
        if (state1 is AllShopLoading) {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: AppColors.primaryColor,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: AppColors.primaryColor,
              title: Text(
                "Store Details",
                style: TextStyle(
                    fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _showBottomSheet(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ShopHistoryScreen(shopData: widget.shopData)));
                  },
                  icon: Icon(Icons.more_vert),
                )
              ],
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(14.sp),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (((int.parse((totalCrateEditingController.text.isEmpty)
                                          ? "0"
                                          : totalCrateEditingController.text) *
                                      int.parse(widget.shopData?["crate_price"] ?? "0")) +
                                  num.parse(
                                      widget.shopData?["current_balance"] ?? "0")) >=
                              num.parse(totalAmountEditingController.text)) {
                            if ((int.parse(totalCrateEditingController.text) <= 0) &&
                                (int.parse(totalAmountEditingController.text) <= 0) &&
                                (int.parse(crateReceivedEditingController.text) <= 0)) {
                              CustomSnackBar()
                                  .snackbarMessage(message: "Please enter valid data");
                            } else {
                              updateDialog(context);
                            }
                          } else {
                            CustomSnackBar()
                                .snackbarMessage(message: "Please check the price");
                          }
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 30.sp,
                        decoration: BoxDecoration(
                          color: AppColors.blueColor,
                          borderRadius: BorderRadius.circular(100.sp),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightColor,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "UPDATE",
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
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        nextScreen(
                            context,
                            ShopHistory(
                              shopId: widget.shopData?["id"],
                              shopName: widget.shopData?["shopName"],
                            ));
                      },
                      child: Container(
                        width: 100,
                        height: 30.sp,
                        decoration: BoxDecoration(
                          color: AppColors.blueColor,
                          borderRadius: BorderRadius.circular(100.sp),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightColor,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "HISTORY",
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
            ),
            body: BlocConsumer<ShopDetailCubit, ShopDetailState>(
              listener: (context, state) {
                if (state is ShopDetailSuccess) {
                  Navigator.pop(context, true);
                }
              },
              builder: (context, state) {
                // if (state is ShopDetailLoading) {
                //   return Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                return Stack(
                  fit: StackFit.loose,
                  children: [
                    ListView(
                      children: [
                        Container(
                          height: 28.h,
                          child: (widget.shopData?["image_url"] ?? "")
                                  .toString()
                                  .isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: widget.shopData?["image_url"],
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        // colorFilter:
                                        // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                )
                              : Image.asset('assets/images/store.png'),
                        ),
                        topContainer(),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4.sp),
                                        child: Text(
                                          "Crates delivered :",
                                          style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        width: 70.sp,
                                        child: Center(
                                            child: CustomTextFormField(
                                          onChanged: (value) {
                                            if (value!.isNotEmpty) {
                                              setState(() {});
                                            }
                                          },
                                          controller: totalCrateEditingController,
                                          keyboardType: TextInputType.numberWithOptions(
                                            decimal: false,
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter number of crates";
                                            }
                                            return null;
                                          },
                                        )),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4.sp),
                                        child: Text(
                                          "Amount Received : ",
                                          style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        width: 70.sp,
                                        child: Center(
                                          child: CustomTextFormField(
                                            onChanged: (value) {
                                              if (value!.isNotEmpty) {
                                                setState(() {});
                                              }
                                            },
                                            controller: totalAmountEditingController,
                                            keyboardType: TextInputType.numberWithOptions(
                                              decimal: false,
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter amount";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 4.sp),
                                        child: Text(
                                          "Crates Received : ",
                                          style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        width: 70.sp,
                                        child: Center(
                                          child: CustomTextFormField(
                                            onChanged: (value) {
                                              if (value!.isNotEmpty) {
                                                setState(() {});
                                              }
                                            },
                                            controller: crateReceivedEditingController,
                                            keyboardType: TextInputType.numberWithOptions(
                                              decimal: false,
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Please enter amount";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.sp, right: 14.sp),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total Amount : ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${int.parse((totalCrateEditingController.text.isEmpty) ? "0" : totalCrateEditingController.text) * int.parse(widget.shopData?["crate_price"] ?? "0")}",
                                    style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50.sp,
                        )
                      ],
                    ),

                    // Positioned(
                    //   width: 100.w,
                    //   bottom: 0,
                    //   child: Row(
                    //     children: [
                    //       CTAButton(onPressed: (){
                    //         FocusScope.of(context).unfocus();
                    //         if (_formKey.currentState!.validate()) {
                    //           if ((int.parse(totalCrateEditingController.text) <= 0) &&
                    //               (int.parse(totalAmountEditingController.text) <= 0) &&
                    //               (int.parse(crateReceivedEditingController.text) <= 0)) {
                    //             CustomSnackBar()
                    //                 .snackbarMessage(message: "Please enter valid data");
                    //           } else {
                    //             updateDialog(context);
                    //           }
                    //         }
                    //       }, label: "UPDATE"),
                    //       // CTAButton(onPressed: (){
                    //       //   FocusScope.of(context).unfocus();
                    //       //   if (_formKey.currentState!.validate()) {
                    //       //     if ((int.parse(totalCrateEditingController.text) <= 0) &&
                    //       //         (int.parse(totalAmountEditingController.text) <= 0) &&
                    //       //         (int.parse(crateReceivedEditingController.text) <= 0)) {
                    //       //       CustomSnackBar()
                    //       //           .snackbarMessage(message: "Please enter valid data");
                    //       //     } else {
                    //       //       updateDialog(context);
                    //       //     }
                    //       //   }
                    //       // }, label: "UPDATE"),
                    //       // InkWell(
                    //       //   onTap: () {
                    //       //     // ConfirmationDialog();
                    //       //     nextScreen(context, ShopHistory(shopId: widget.shopData?["id"]));
                    //       //   },
                    //       //   child: Container(
                    //       //     width: 40.w,
                    //       //     margin: EdgeInsets.all(14.sp),
                    //       //     padding: EdgeInsets.symmetric(vertical: 10.sp),
                    //       //     decoration: BoxDecoration(
                    //       //       borderRadius: BorderRadius.circular(20),
                    //       //       color: Colors.white,
                    //       //       boxShadow: [
                    //       //         BoxShadow(
                    //       //           color: AppColors.whiteColor.withOpacity(0.2),
                    //       //           blurRadius: 4,
                    //       //           spreadRadius: 0,
                    //       //           offset: Offset(0, 0),
                    //       //         ),
                    //       //       ],
                    //       //     ),
                    //       //     child: Center(
                    //       //       child: Text("HISTORY",
                    //       //           style: TextStyle(
                    //       //               color: AppColors.whiteColor, fontSize: 12.sp)),
                    //       //     ),
                    //       //   ),
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                    if (state is ShopDetailLoading)
                      Positioned.fill(
                        child: Container(
                          color: AppColors.whiteColor.withOpacity(0.2),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }

  Container topContainer() {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.shopData?["shopName"] ?? "",
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Crate Amount :   ",
                      style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.shopData?["crate_price"] ?? "",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4.sp),
            child: Text(
              widget.shopData?["ownerName"] ?? "",
              style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.5),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4.sp),
            child: Text(
              widget.shopData?["address"] ?? "",
              style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Current Balance :   ",
                      style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.shopData?["current_balance"] ?? "",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Remaining Crates : ",
                      style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.shopData?["remaining_crates"] ?? "",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Line Name :   ",
                    style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    (widget.shopData?["line_name"] ?? "").toString().isEmpty
                        ? "Unavailable"
                        : widget.shopData?["line_name"],
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Phone :   ",
                    style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    (widget.shopData?["phone"] ?? "").toString().isEmpty
                        ? "Unavailable"
                        : widget.shopData?["phone"],
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 8.sp,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Line No :   ",
                style: TextStyle(
                    color: AppColors.lightColor,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                (widget.shopData?["line_number"].toString() ?? "").toString().isEmpty
                    ? "Unavailable"
                    : (widget.shopData?["line_number"]).toString(),
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                // leading: Icon(Icons.delete),
                title: Center(
                  child: Text('Delete Store',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onTap: () {
                  // Call function to delete store
                  Navigator.pop(context);
                  _showDeleteStoreDialog(context);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.sp),
                child: Divider(
                  color: AppColors.lightColor,
                ),
              ),
              ListTile(
                // leading: Icon(Icons.block),
                title: Center(
                  child: Text(
                      widget.shopData?["is_blocked"] ? 'Unblock Store' : "Block Store",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onTap: () {
                  // Call function to delete store
                  Navigator.pop(context);
                  _showBlockStoreDialog(context);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.sp),
                child: Divider(
                  color: AppColors.lightColor,
                ),
              ),
              ListTile(
                // leading: Icon(Icons.edit),
                title: Center(
                  child: Text('Edit Crate Amount',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onTap: () {
                  // Call function to edit crate amount
                  Navigator.pop(context);
                  _showEditCrateAmountDialog(context);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.sp),
                child: Divider(
                  color: AppColors.lightColor,
                ),
              ),
              ListTile(
                // leading: Icon(Icons.edit),
                title: Center(
                  child: Text('Edit Shop Details',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onTap: () {
                  nextScreen(
                      context,
                      CreateVendorScreen(
                        shopData: widget.shopData,
                      ));
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.sp),
                child: Divider(
                  color: AppColors.lightColor,
                ),
              ),
              ListTile(
                // leading: Icon(Icons.edit),
                title: Center(
                  child: Text('Edit Line Details',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onTap: () {
                  _showEditLine(
                    context,
                    widget.shopData?["id"] ?? "",
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
                // leading: Icon(Icons.photo),
                title: Center(
                  child: Text('Add Store Photo',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);
                  if (pickedFile != null) {
                    shopDetailCubit!.uploadImageToFirebaseStorage(
                        File(pickedFile.path), widget.shopData?["id"], context);
                  } else {
                    CustomSnackBar().errorSnackBar(message: 'No image selected.');

                    // return null;
                  }
                  // }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteStoreDialog(BuildContext context) {
    String? pin = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Delete Store',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                labelText: 'Pin',
                obscureText: true,
                onChanged: (value) {
                  pin = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (pin == null || pin!.isEmpty) {
                  CustomSnackBar().errorSnackBar(message: 'Please enter pin.');
                  return;
                } else {
                  Navigator.pop(context);
                  shopDetailCubit!.deleteShopData(widget.shopData?["id"], pin);
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showBlockStoreDialog(BuildContext context) {
    String? pin = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            widget.shopData?["is_blocked"] ? 'Unblock Store' : "Block Store",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //     'Enter your pin to ${widget.shopData?["is_blocked"] ? 'unblock' : "block"} the store:'),
              CustomTextFormField(
                labelText: 'Pin',
                obscureText: true,
                onChanged: (value) {
                  pin = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (pin == null || pin!.isEmpty) {
                  CustomSnackBar().errorSnackBar(message: 'Pin is required.');
                  return;
                } else {
                  Navigator.pop(context);
                  shopDetailCubit!.blockShopData(
                      widget.shopData?["id"], pin, widget.shopData?["is_blocked"]);
                }
              },
              child: Text(widget.shopData?["is_blocked"] ? 'Unblock' : "Block"),
            ),
          ],
        );
      },
    );
  }

  void _showEditCrateAmountDialog(BuildContext context) {
    String? pin = '';
    int? newCrateAmount = 0; // The new crate amount entered by the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Edit Crate Amount',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                labelText: 'New Crate Amount',
                obscureText: true,
                onChanged: (value) {
                  newCrateAmount = int.tryParse(value!) ?? 0;
                },
              ),
              SizedBox(height: 16.sp),
              // Text('Enter your pin to edit the crate amount:'),
              CustomTextFormField(
                labelText: 'Pin',
                obscureText: true,
                onChanged: (value) {
                  pin = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newCrateAmount == 0) {
                  CustomSnackBar()
                      .errorSnackBar(message: 'Please enter a valid crate amount.');
                  return;
                } else if (pin == null) {
                  CustomSnackBar().errorSnackBar(message: 'Please enter your pin.');
                  return;
                } else {
                  Navigator.pop(context);
                  shopDetailCubit!
                      .editCrateAmount(widget.shopData?["id"], pin, newCrateAmount);
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void updateDialog(BuildContext context) {
    // The new crate amount entered by the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryColor,
          title: Center(
              child: Text(
            'Are you sure',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Crates Delivered :   ",
                    style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    totalCrateEditingController.text,
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Amount received :   ",
                    style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    totalAmountEditingController.text,
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Crates Received :   ",
                    style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    crateReceivedEditingController.text,
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();

                String currentBalance =
                    (int.parse(widget.shopData?["current_balance"] ?? "0") +
                            (int.parse(totalCrateEditingController.text.isEmpty
                                    ? "0"
                                    : totalCrateEditingController.text) *
                                int.parse(widget.shopData?["crate_price"] ?? "0")) -
                            int.parse(totalAmountEditingController.text.isEmpty
                                ? "0"
                                : totalAmountEditingController.text))
                        .toString();
                String totalCrates = (int.parse(
                            widget.shopData?["remaining_crates"] ?? "0") +
                        (int.parse(totalCrateEditingController.text.isEmpty
                            ? "0"
                            : totalCrateEditingController.text)) -
                        int.parse(crateReceivedEditingController.text.isEmpty
                            ? "0"
                            : crateReceivedEditingController.text))
                    .toString();
                context.read<ShopDetailCubit>().updateShopData(
                    widget.shopData?["shopName"],
                    widget.shopData?["ownerName"],
                    currentBalance,
                    totalCrates,
                    totalCrateEditingController.text.isEmpty
                        ? "0"
                        : totalCrateEditingController.text,
                    totalAmountEditingController.text.isEmpty
                        ? "0"
                        : totalAmountEditingController.text,
                    crateReceivedEditingController.text.isEmpty
                        ? "0"
                        : crateReceivedEditingController.text,
                    widget.shopData?["id"],
                    context);
                // shopDetailCubit!.editCrateAmount(widget.shopData?["id"], pin, newCrateAmount);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showEditLine(BuildContext context, String? id) {
    context.read<CreateVendorCubit>().emit(CreateVendorInitial());
    String? pin = '';
    int? newCrateAmount = 0; // The new crate amount entered by the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Add Line',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: BlocBuilder<CreateVendorCubit, CreateVendorState>(
            builder: (context, state) {
              if (state is CreateVendorInitial) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    state.id != null
                        ? Column(
                            children: [
                              SizedBox(height: 10.0),
                              Text(
                                (state.name ?? "unavailable").toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              CustomTextFormField(
                                labelText: 'Line Number',
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  pin = value;
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<CreateVendorCubit>()
                                          .emit(CreateVendorInitial());
                                    },
                                    child: Text(
                                      'Remove Line',
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (pin!.isEmpty || num.parse(pin!) == 0) {
                                        CustomSnackBar().snackbarMessage(
                                            message: 'Please enter valid line number');
                                      } else {
                                        context.read<AllShopCubit>().updateLine(
                                            state.id!, pin!, state.name!, id!,
                                            updateShopLine: true);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text('Update'),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  nextScreen(
                                      context,
                                      GetLinesScreen(
                                        isSearch: true,
                                      ));
                                },
                                child: Text(
                                  '+ Add Line',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                );
              } else {
                return Center(
                    child: Text(
                  'Please wait...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ));
              }
            },
          ),
          actions: [],
        );
      },
    );
  }
}

class ConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? message;

  // final Function(List<String>)? onConfirm;

  ConfirmationDialog({this.title, this.message});

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  final List<TextEditingController> _controllers =
      List.generate(3, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
      // actions: [
      //   FlatButton(
      //     child: Text('CANCEL'),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      //   FlatButton(
      //     child: Text('CONFIRM'),
      //     onPressed: () {
      //       widget.onConfirm(_controllers.map((controller) => controller.text).toList());
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ],
    );
  }
}
