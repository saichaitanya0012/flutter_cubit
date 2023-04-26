import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/all_shops/all_shops_view.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_screen.dart';
import 'package:goli_soda/src/features/home/home_cubit.dart';
import 'package:goli_soda/src/features/shop_detail/shop_detail_view.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/custom_search.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  final String? id;
  final String? name;

  const HomeScreen({Key? key, this.id, this.name}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  HomeCubit? homeCubit;

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit!.getRegionCollectionData(id: widget.id);
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
            "${widget.name ?? ''}  Line".toUpperCase(),
            style: TextStyle(
                fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    AllShopsView(
                      isAllShops: false,
                    ));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
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
            return homeCubit!.getRegionCollectionData(id: widget.id);
          },
          child: ListView(
            children: [
              search(),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
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
                        : Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10.sp),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.lightColor.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(14.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Pending collection",
                                            style: TextStyle(
                                                color: AppColors.lightColor,
                                                fontSize: 8.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.sp),
                                            child: Text(
                                              "${state.pendingAmount ?? 0}",
                                              style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
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
                                                      shopData:
                                                          state.jsonList?[index]))) ??
                                          false;
                                      if (reload) {
                                        homeCubit!.getRegionCollectionData();
                                      }
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(14.sp),
                                        decoration: BoxDecoration(
                                            color: index % 2 == 0
                                                ? Colors.grey.withOpacity(0.1)
                                                : Colors.transparent),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                            (state.jsonList?[index]["is_blocked"] ??
                                                    false)
                                                ? Icon(
                                                    Icons.block,
                                                    color: Colors.red,
                                                  )
                                                : Container(),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ],
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
          homeCubit!.getRegionCollectionData(keyword: value, id: widget.id);
        } else if (value.isEmpty) {
          homeCubit!.getRegionCollectionData(id: widget.id);
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
