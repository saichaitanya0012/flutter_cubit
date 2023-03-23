import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/all_shops/cubit/all_shop_cubit.dart';
import 'package:goli_soda/src/features/auth/widget/custom_textfield.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_cubit.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_screen.dart';
import 'package:goli_soda/src/features/get_lines/get_lines_view.dart';
import 'package:goli_soda/src/features/home/home_cubit.dart';
import 'package:goli_soda/src/features/shop_detail/shop_detail_view.dart';
import 'package:goli_soda/src/utils/circular_textfield.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/custom_search.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:sizer/sizer.dart';

class AllShopsView extends StatefulWidget {
  final bool isAllShops;
  const AllShopsView({Key? key, this.isAllShops=true}) : super(key: key);

  @override
  State<AllShopsView> createState() => _AllShopsViewState();
}

class _AllShopsViewState extends State<AllShopsView> {
  AllShopCubit? allShopCubit;

  @override
  void initState() {
    allShopCubit = BlocProvider.of<AllShopCubit>(context);
    allShopCubit!.getAllShopsData(isAllShops: widget.isAllShops);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          title: Text(
            "All Shops".toUpperCase(),
            style: TextStyle(
                fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),

        // floatingActionButton: InkWell(
        //   onTap: () async {
        //     bool reload = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateVendorScreen())) ?? false;
        //     if (reload) {
        //       homeCubit!.getRegionCollectionData();
        //     }
        //   },
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20),
        //       color: Colors.blue,
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.all(12.0),
        //       child: Text(
        //         "Create Store",
        //         style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white),
        //       ),
        //     ),
        //   ),
        // ),
        body: RefreshIndicator(
          onRefresh: () {
            return allShopCubit!.getAllShopsData(isAllShops: widget.isAllShops);
          },
          child: ListView(
            children: [
              search(),
              BlocConsumer<AllShopCubit, AllShopState>(
                listener: (context, state) {
                  if (state is AllShopLoaded) {
                    if (state.jsonList?.isEmpty ?? true) {
                      context.read<AllShopCubit>().getAllShopsData(isAllShops: widget.isAllShops);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is AllShopLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is AllShopLoaded) {
                    return (state.jsonList ?? []).isEmpty
                        ? Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: state.jsonList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  bool reload = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShopDetailScreen(
                                                  shopData: state.jsonList?[index]))) ??
                                      false;
                                  if (reload) {
                                    allShopCubit!.getAllShopsData(isAllShops: widget.isAllShops);
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(14.sp),
                                    decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? Colors.grey.withOpacity(0.1)
                                            : Colors.transparent),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (state.jsonList?[index]["shopName"] ??
                                                      "unavailable")
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: AppColors.whiteColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 4.sp,
                                            ),
                                            Text(
                                              state.jsonList?[index]["address"] ??
                                                  "unavailable",
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.lightColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            (state.jsonList?[index]["is_blocked"] ?? false)
                                                ? Icon(
                                              Icons.block,
                                              color: Colors.red,
                                             )
                                                : Container(),
                                            (state.jsonList?[index]["line_id"]??"").toString().isNotEmpty?SizedBox():InkWell(
                                              onTap: () {
                                                _showEditCrateAmountDialog(context, state.jsonList?[index]["id"].toString());
                                              },
                                              child: Padding(
                                                padding:  EdgeInsets.all(8.sp),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      size: 14.sp,
                                                      color: AppColors.lightColor,
                                                    ),
                                                    Text(
                                                      "Add Line",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontWeight: FontWeight.w500,
                                                          color: AppColors.lightColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )

                                      ],
                                    )),
                              );
                            },
                          );
                  } else {
                    return Text("Error");
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget search() {
    return SearchField(
      onChanged: (value) {
        if (value.length > 2) {
          allShopCubit!.getAllShopsData(keyword: value,isAllShops: widget.isAllShops);
        } else if (value.isEmpty) {
          allShopCubit!.getAllShopsData(isAllShops: widget.isAllShops);
        }
      },
    );
  }

  void _showEditCrateAmountDialog(BuildContext context,String? id) {
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
                                      if( pin!.isEmpty||num.parse(pin!)==0){
                                        CustomSnackBar().snackbarMessage(message:  'Please enter valid line number');
                                      }else{
                                        context.read<AllShopCubit>().updateLine(state.id!,pin!, state.name!, id!);
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
          actions: [

          ],
        );
      },
    );
  }
}
