import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/all_shops/all_shops_view.dart';
import 'package:goli_soda/src/features/auth/widget/custom_textfield.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_cubit.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_screen.dart';
import 'package:goli_soda/src/features/get_lines/cubit/get_lines_cubit.dart';
import 'package:goli_soda/src/features/home/home_screen.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/custom_search.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:sizer/sizer.dart';

class GetLinesScreen extends StatefulWidget {
  final bool? isSearch;

  const GetLinesScreen({Key? key, this.isSearch = false}) : super(key: key);

  @override
  State<GetLinesScreen> createState() => _GetLinesScreenState();
}

class _GetLinesScreenState extends State<GetLinesScreen> {
  GetLinesCubit? homeCubit;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    homeCubit = BlocProvider.of<GetLinesCubit>(context);
    homeCubit!.getRegionCollectionData();

    _scrollController.addListener(() {
      var nextPageTrigger = _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels == nextPageTrigger) {
        // homeCubit!.getRegionCollectionData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "House of Goli Soda",
            style: TextStyle(
                fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          actions: [
            widget.isSearch!?SizedBox():InkWell(
              onTap: () {
                _showBottomSheet(context);
                // _showEditCrateAmountDialog(context);
              },
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return homeCubit!.getRegionCollectionData();
          },
          child: ListView(
            children: [
              search(),
              BlocBuilder<GetLinesCubit, GetLinesState>(
                builder: (context, state) {
                  if (state is GetLinesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GetLinesLoaded) {
                    return state.jsonList.isEmpty
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
                      controller: _scrollController,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: state.jsonList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  if (widget.isSearch!) {
                                    context.read<CreateVendorCubit>().emit(
                                        CreateVendorInitial(
                                            id: state.jsonList?[index]["id"],
                                            name: state.jsonList?[index]["name"]));
                                    Navigator.pop(context);
                                  } else {
                                    nextScreen(
                                        context,
                                        HomeScreen(
                                          id: state.jsonList?[index]["id"],
                                          name: state.jsonList?[index]["name"],
                                        ));
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(14.sp),
                                    decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? Colors.grey.withOpacity(0.1)
                                            : Colors.transparent),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (state.jsonList?[index]["name"] ??
                                                  "unavailable")
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.w500),
                                        ),
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
          homeCubit!.getRegionCollectionData(keyword: value);
        } else if (value.isEmpty) {
          homeCubit!.getRegionCollectionData();
        }
      },
    );
  }

  void _showEditCrateAmountDialog(BuildContext context) {
    String? pin = '';
    String? newCrateAmount = ""; // The new crate amount entered by the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryColor,
          title: Center(
            child: Text(
              'Add Line',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                labelText: 'New line name',
                onChanged: (value) {
                  newCrateAmount = value;
                },
              ),
              SizedBox(height: 16.sp),
              CustomTextFormField(
                labelText: 'Pin',
                onChanged: (value) {
                  pin = value;
                },
                obscureText: true,
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
                Navigator.pop(context);
                context.read<GetLinesCubit>().addLine(
                      pin,
                      newCrateAmount,
                    );
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
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
                  title: Center(
                    child: Text('All Shops',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  onTap: () {
                    // Call function to delete store
                    Navigator.pop(context);
                    nextScreen(context, AllShopsView(

                    ));
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.sp),
                  child: Divider(
                    color: AppColors.lightColor,
                  ),
                ),ListTile(
                  title: Center(
                    child: Text('Add Line',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  onTap: () {
                    // Call function to delete store
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
                  title: Center(
                    child: Text('Create Shop',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    nextScreen(context, CreateVendorScreen());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
