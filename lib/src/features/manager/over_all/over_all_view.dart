import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/manager/over_all/cubit/over_all_cubit.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/custom_data_table.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class OverAllScreen extends StatefulWidget {
  const OverAllScreen({Key? key}) : super(key: key);

  @override
  State<OverAllScreen> createState() => _OverAllScreenState();
}

class _OverAllScreenState extends State<OverAllScreen> {
  OverAllCubit? overAllCubit;

  @override
  void initState() {
    overAllCubit = BlocProvider.of<OverAllCubit>(context);
    overAllCubit!.getOverAllDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('Detail Reports'),
      ),
      body: BlocBuilder<OverAllCubit, OverAllState>(
        builder: (context, state) {
          if (state is OverAllLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OverAllSuccess) {
            return state.jsonList.isEmpty
                ? Text(
              'No Data Found',
              style: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp),
              textAlign: TextAlign.center,
            )
                : CustomDataTable(
              fixedCornerCell: 'Date',
              fixedColWidth: 70.sp,
              cellHeight: 40.sp,
              cellWidth: 100.sp,
              borderColor: AppColors.lightColor,
              rowsCells: state.jsonList
                  .map((e) => [
                // e['date'],
                e['total_crates'],
                e['total_collection'],
                e['crates_sold'],
                e["expenses"],
              ])
                  .toList(),
              fixedColCells: state.jsonList
                  .map((e) => DateFormat('d MMM yy').format(e['date'].toDate()))
                  .toList(),
              fixedRowCells: [
                "Total Crates",
                "Total Collection",
                "Crates Sold",
                "Expenses",
              ],
            );
          } else {
            return const Center(child: Text('No Data Found'));
          }
        },
      ),
    );
  }
}
