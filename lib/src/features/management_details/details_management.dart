import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/management_details/cubit/management_details_cubit.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/custom_data_table.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DetailManagement extends StatefulWidget {
  const DetailManagement({Key? key}) : super(key: key);

  @override
  State<DetailManagement> createState() => _DetailManagementState();
}

class _DetailManagementState extends State<DetailManagement> {
  ManagementDetailsCubit? managementDetailsCubit;

  @override
  void initState() {
    managementDetailsCubit = BlocProvider.of<ManagementDetailsCubit>(context);
    managementDetailsCubit!.getManagementDetails();
    // TODO: implement initState
    super.initState();
  }

  String expensesToString(List<dynamic> expenses) {
    String expensesString = '';
    expenses.forEach((element) {
      expensesString += element['type'] + ' : ' + element['amount'].toString() + '\n';
    });
    return expensesString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text('Detail Reports'),
        ),
        body: BlocConsumer<ManagementDetailsCubit, ManagementDetailsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is ManagementDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ManagementDetailsSuccess) {
              return state.jsonList.isEmpty?
              Text(
                'No Data Found',
                style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp),
                textAlign: TextAlign.center,
              ):CustomDataTable(
                fixedCornerCell: 'Date',
                fixedColWidth: 70.sp,
                cellHeight: 40.sp,
                cellWidth: 100.sp,
                borderColor: Colors.grey.shade300,
                rowsCells: state.jsonList.map((e) => [
                  e['line_collection'],
                  e['other_collection'],
                  e['total_collection'],
                  expensesToString(e['expenses'])
                ]).toList(),
                fixedColCells: state.jsonList.map((e) => DateFormat('d MMM yy').format(e['date'].toDate())).toList(),
                fixedRowCells: [
                  "Line Collection",
                  "Other Collection",
                  "Total Collection",
                  "Expenses",
                ],
              );
            } else {
              return const Center(child: Text('No Data Found'));
            }
          },
        ));
  }
}
