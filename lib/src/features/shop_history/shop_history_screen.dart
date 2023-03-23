import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/shop_history/shop_history_cubit.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

class ShopHistory extends StatefulWidget {
  final String? shopId;
  final String? shopName;
   ShopHistory({Key? key,this.shopId,this.shopName}) : super(key: key);

  @override
  State<ShopHistory> createState() => _ShopHistoryState();
}

class _ShopHistoryState extends State<ShopHistory> {
  ShopHistoryCubit? shopHistoryCubit ;
  @override
  void initState() {
    shopHistoryCubit = BlocProvider.of<ShopHistoryCubit>(context);
    shopHistoryCubit!.getShopHistoryData(shopId: widget.shopId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:  AppColors.primaryColor,
        title: Text('${widget.shopName} History'),
      ),
      body: BlocConsumer<ShopHistoryCubit, ShopHistoryState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state)
        {
          if(state is ShopHistoryLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(state is ShopHistoryLoaded){
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Shop Name :  ",
                                    style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                Text(data['shopName'] ?? "",
                                    style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Bal : ",
                                    style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                Text(data['current_balance'] ?? "",
                                    style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: 4.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Amount : ",
                                      style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                  Text(data['amount_received'] ?? "",
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Crates : ",
                                      style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                  Text(data['crate_delivered'] ?? "",
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 4.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Crate Received : ",
                                      style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                  Text(data['crate_received'] ?? "",
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Remaining Crates : ",
                                      style: TextStyle(color: AppColors.lightColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                  Text(data['remaining_crates'] ?? "",
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:  EdgeInsets.symmetric(vertical: 4.sp),
                              child: Row(
                                children: [
                                  Text("Updated by : ",
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: 8.sp, fontWeight: FontWeight.w500)),
                                  Text((data['created_by'] ?? "").split("@")[0],
                                      style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),Text(
                                DateFormat('do MMM yyyy, h:mm a')
                                    .format(data['created_at'].toDate()),
                                style: TextStyle(
                                    color: AppColors.whiteColor.withOpacity(0.8),
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
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
