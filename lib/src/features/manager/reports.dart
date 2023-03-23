import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:goli_soda/src/features/line_details/details_line.dart';
import 'package:goli_soda/src/features/line_details/line_details_view.dart';
import 'package:goli_soda/src/features/management_details/details_management.dart';
import 'package:goli_soda/src/features/management_details/management_detail_view.dart';
import 'package:goli_soda/src/features/manager/over_all/over_all_view.dart';
import 'package:goli_soda/src/features/manager/widget/custom_card.dart';
import 'package:goli_soda/src/features/production_details/detail_production.dart';
import 'package:goli_soda/src/features/production_details/production_details_view.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:sizer/sizer.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: EdgeInsets.all(14.sp),
        child: Column(
          children: [

            CustomCard(
                text: "OverAll Report",
                onTap: () {
                  nextScreen(context, OverAllScreen());
                }),

            CustomCard(
                text: "Production Report",
                onTap: () {
                  nextScreen(context, DetailProduction());
                }),
            CustomCard(
                text: "Management Report",
                onTap: () {
                  nextScreen(context, DetailManagement());
                }),
            CustomCard(
                text: "Line Report",
                onTap: () {
                  nextScreen(context, DetailsLine());
                }),
          ],
        ),
      ),
    );
  }
}
