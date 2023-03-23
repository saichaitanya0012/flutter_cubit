import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/manager/day_report_cubit/day_report_cubit.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DayReport extends StatefulWidget {
  const DayReport({Key? key}) : super(key: key);

  @override
  State<DayReport> createState() => _DayReportState();
}

class _DayReportState extends State<DayReport> {
  DayReportCubit? dayReportCubit ;
  @override
  void initState() {
    dayReportCubit = BlocProvider.of<DayReportCubit>(context);
    dayReportCubit!.getDayReportData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      body: BlocConsumer<DayReportCubit, DayReportState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state)
        {
          if(state is DayReportLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(state is DayReportSuccess){
            return ListView.builder(
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                DateFormat('d MMM yyyy')
                                    .format(data['date'].toDate()),
                                style: TextStyle(
                                    color: AppColors.whiteColor.withOpacity(0.8),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(
                          height: 20.sp,

                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Total Amount :  ",
                                    style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                Text((data['total_amount'] ?? "").toString(),
                                    style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Total Crates : ",
                                    style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                Text((data['total_crates'] ?? "").toString(),
                                    style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                        // Padding(
                        //   padding:  EdgeInsets.only(top: 4.sp),
                        //   child: Row(
                        //     children: [
                        //       Text("Total Crates : ",
                        //           style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                        //       Text((data['total_crates'] ?? "").toString(),
                        //           style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding:  EdgeInsets.symmetric(vertical: 4.sp),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Text("Crate Received : ",
                        //               style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                        //           Text(data['crate_received'] ?? "",
                        //               style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                        //         ],
                        //       ),
                        //       Row(
                        //         children: [
                        //           Text("Remaining Crates : ",
                        //               style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                        //           Text(data['remaining_crates'] ?? "",
                        //               style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),

                      ],
                    ),
                  );
                }
            );
          }else{
            return Center(
              child: Text("No Data"),
            );
          }

        },
      ),
    );
  }
}