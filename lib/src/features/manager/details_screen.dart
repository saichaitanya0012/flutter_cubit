import 'package:flutter/material.dart';
import 'package:goli_soda/src/features/line_details/line_details_view.dart';
import 'package:goli_soda/src/features/management_details/management_detail_view.dart';
import 'package:goli_soda/src/features/manager/widget/custom_card.dart';
import 'package:goli_soda/src/features/production_details/production_details_view.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:sizer/sizer.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: EdgeInsets.all(14.sp),
        child: Column(
          children: [
            CustomCard(
                text: "Production Details",
                onTap: () {
                  nextScreen(context, ProductionDetailsScreen());
                }),
            CustomCard(
                text: "Management Details",
                onTap: () {
                  nextScreen(context, ManagementDetailsScreen());
                }),
            CustomCard(
                text: "Line Details",
                onTap: () {
                  nextScreen(context, LineDetails());
                }),
          ],
        ),
      ),
    );
  }
}
