import 'package:flutter/material.dart';
import 'package:goli_soda/src/features/manager/day_report.dart';
import 'package:goli_soda/src/features/manager/details_screen.dart';
import 'package:goli_soda/src/features/manager/manager_screen.dart';
import 'package:goli_soda/src/features/manager/reports.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';

class ManagerTabs extends StatefulWidget {
  const ManagerTabs({Key? key}) : super(key: key);

  @override
  State<ManagerTabs> createState() => _ManagerTabsState();
}

class _ManagerTabsState extends State<ManagerTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: const Text('Manager'),
          bottom: TabBar(
            tabs: const [
              Tab(
                text: ' Details',
              ),
              Tab(
                text: 'Report',
              ),
              Tab(
                text: 'Day Report',
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: const [
           DetailsScreen(),
            ReportScreen(),
            DayReport(),
          ],
        ),
      ),
    );
  }
}
