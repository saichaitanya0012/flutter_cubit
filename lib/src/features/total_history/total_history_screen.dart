import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/total_history/total_collection/total_collection_cubit.dart';
import 'package:goli_soda/src/features/total_history/total_history_cubit/total_history_cubit.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TotalHistory extends StatefulWidget {
  const TotalHistory({Key? key}) : super(key: key);

  @override
  State<TotalHistory> createState() => _TotalHistoryState();
}

class _TotalHistoryState extends State<TotalHistory> {
  TotalHistoryCubit? totalHistoryCubit;
  TotalCollectionCubit? totalCollectionCubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    totalHistoryCubit = BlocProvider.of<TotalHistoryCubit>(context);
    totalCollectionCubit = BlocProvider.of<TotalCollectionCubit>(context);
    totalHistoryCubit!.getHistoryData();
    totalCollectionCubit!.getCollectedData();

    _scrollController.addListener(() {
      var nextPageTrigger = _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels == nextPageTrigger) {
        totalHistoryCubit!.loadMore();
      }
    });
    super.initState();
  }

  DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      initialValue: [DateTime.now()],
      borderRadius: BorderRadius.circular(15),
    );
    // print(res);
    if (results!.isNotEmpty) {
      totalHistoryCubit!.getHistoryData(keyword: results);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: Text('Total History'),
        actions: [
          IconButton(
              onPressed: () {
                // datePicker();
                _selectDate(context);
              },
              icon: Icon(Icons.calendar_today))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          totalHistoryCubit!.getHistoryData();
          totalCollectionCubit!.getCollectedData();
        },
        child: ListView(
          controller: _scrollController,
          children: [
            BlocBuilder<TotalCollectionCubit, TotalCollectionState>(
              builder: (context, state) {
                if (state is TotalCollectionLoading) {
                  return collectionLoading();
                } else if (state is TotalCollectionLoaded) {
                  var data = state.jsonList!.isNotEmpty
                      ? state.jsonList![0]
                      : {
                          "amount": "0",
                          "date":
                              DateFormat('dd-MMM-yyyy').format(DateTime.now()).toString()
                        };
                  return Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total collection",
                                style: TextStyle(
                                    color: AppColors.lightColor,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.sp),
                                child: Text(
                                  "${data['total_amount'] ?? 0}",
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Crates Delivered",
                                style: TextStyle(
                                    color: AppColors.lightColor,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.sp),
                                child: Text(
                                  "${data['total_crates'] ?? 0}",
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
                  );
                } else if (state is TotalCollectionError) {
                  return Container(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Error"),
                      ],
                    ),
                  );
                }
                return Container(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("No Data"),
                    ],
                  ),
                );
              },
            ),
            BlocConsumer<TotalHistoryCubit, TotalHistoryState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is TotalHistoryLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.1),
                    highlightColor: Colors.white,
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          var data = {};
                          return Container(
                            padding: EdgeInsets.all(10.sp),
                            margin: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Shop Name :  ",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 8.sp,
                                                fontWeight: FontWeight.w500)),
                                        Text(data['shopName'] ?? "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Bal : ",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 8.sp,
                                                fontWeight: FontWeight.w500)),
                                        Text(data['current_balance'] ?? "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Amount : ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 8.sp,
                                                  fontWeight: FontWeight.w500)),
                                          Text(data['amount_received'] ?? "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Crates : ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 8.sp,
                                                  fontWeight: FontWeight.w500)),
                                          Text(data['crate_delivered'] ?? "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Crate Received : ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 8.sp,
                                                  fontWeight: FontWeight.w500)),
                                          Text(data['crate_received'] ?? "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Remaining Crates : ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 8.sp,
                                                  fontWeight: FontWeight.w500)),
                                          Text(data['remaining_crates'] ?? "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4.sp),
                                      child: Row(
                                        children: [
                                          Text("Updated by : ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 8.sp,
                                                  fontWeight: FontWeight.w500)),
                                          Text((data['created_by'] ?? "").split("@")[0],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    Text("",
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.8),
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                } else if (state is TotalHistoryLoaded) {
                  return state.jsonList!.isEmpty
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
                            Padding(
                              padding: EdgeInsets.all(14.sp),
                              child: Divider(
                                color: Colors.grey.withOpacity(0.5),
                                thickness: 1,
                              ),
                            ),
                            state.showSearch!
                                ? Container(
                                    margin: EdgeInsets.all(10.sp),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.lightColor.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset:
                                              Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(14.sp),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total collection",
                                                style: TextStyle(
                                                    color: AppColors.lightColor,
                                                    fontSize: 8.sp,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 8.sp),
                                                child: Text(
                                                  "${state.totalMoney ?? 0}",
                                                  style: TextStyle(
                                                      color: AppColors.whiteColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Crates Delivered",
                                                style: TextStyle(
                                                    color: AppColors.lightColor,
                                                    fontSize: 8.sp,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 8.sp),
                                                child: Text(
                                                  "${state.totalCratesToday ?? 0}",
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
                                  )
                                : Container(),
                            ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: state.jsonList!.length,
                                itemBuilder: (context, index) {
                                  var data = state.jsonList![index];
                                  return Container(
                                    padding: EdgeInsets.all(10.sp),
                                    margin: EdgeInsets.all(10.sp),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.lightColor.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset:
                                              Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Shop Name :  ",
                                                    style: TextStyle(
                                                        color: AppColors.lightColor,
                                                        fontSize: 8.sp,
                                                        fontWeight: FontWeight.w500)),
                                                Text(data['shopName'] ?? "",
                                                    style: TextStyle(
                                                        color: AppColors.whiteColor,
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Bal : ",
                                                    style: TextStyle(
                                                        color: AppColors.lightColor,
                                                        fontSize: 8.sp,
                                                        fontWeight: FontWeight.w500)),
                                                Text(data['current_balance'] ?? "",
                                                    style: TextStyle(
                                                        color: AppColors.whiteColor,
                                                        fontSize: 12.sp,
                                                        fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4.sp),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Amount : ",
                                                      style: TextStyle(
                                                          color: AppColors.lightColor,
                                                          fontSize: 8.sp,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(data['amount_received'] ?? "",
                                                      style: TextStyle(
                                                          color: AppColors.whiteColor,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Crates : ",
                                                      style: TextStyle(
                                                          color: AppColors.lightColor,
                                                          fontSize: 8.sp,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(data['crate_delivered'] ?? "",
                                                      style: TextStyle(
                                                          color: AppColors.whiteColor,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 4.sp),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Crate Received : ",
                                                      style: TextStyle(
                                                          color: AppColors.lightColor,
                                                          fontSize: 8.sp,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(data['crate_received'] ?? "",
                                                      style: TextStyle(
                                                          color: AppColors.whiteColor,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Remaining Crates : ",
                                                      style: TextStyle(
                                                          color: AppColors.lightColor,
                                                          fontSize: 8.sp,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(data['remaining_crates'] ?? "",
                                                      style: TextStyle(
                                                          color: AppColors.whiteColor,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.symmetric(vertical: 4.sp),
                                              child: Row(
                                                children: [
                                                  Text("Updated by : ",
                                                      style: TextStyle(
                                                          color: AppColors.whiteColor,
                                                          fontSize: 8.sp,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(
                                                      (data['created_by'] ?? "")
                                                          .split("@")[0],
                                                      style: TextStyle(
                                                          color: AppColors.whiteColor,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ),
                                            Text(
                                                DateFormat('d MMM yyyy, h:mm a')
                                                    .format(data['created_at'].toDate()),
                                                style: TextStyle(
                                                    color: AppColors.whiteColor
                                                        .withOpacity(0.8),
                                                    fontSize: 6.sp,
                                                    fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            state.loadMore!
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(),
                            SizedBox(
                              height: 20.sp,
                            )
                          ],
                        );
                } else {
                  return Center(
                    child: Text("No Data"),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Shimmer collectionLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.white,
      child: Container(
        margin: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total collection",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 8.sp, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.sp),
                    child: Text(
                      "",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Crates Delivered",
                    style: TextStyle(
                        color: Colors.grey, fontSize: 8.sp, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.sp),
                    child: Text(
                      "",
                      style: TextStyle(
                          color: Colors.black,
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
    );
  }
}
