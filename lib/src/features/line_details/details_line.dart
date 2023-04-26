import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/line_details/cubits/line_details_cubit.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/custom_data_table.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DetailsLine extends StatefulWidget {
  const DetailsLine({Key? key}) : super(key: key);

  @override
  State<DetailsLine> createState() => _DetailsLineState();
}

class _DetailsLineState extends State<DetailsLine> {
  LineDetailsCubit? lineDetailsCubit;

  @override
  void initState() {
    lineDetailsCubit = BlocProvider.of<LineDetailsCubit>(context);
    lineDetailsCubit!.getLineDetails();
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
        body: BlocConsumer<LineDetailsCubit, LineDetailsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is LineDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LineDetailsSuccess) {
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
                  e['line_name'],
                  e['crates_sent'],
                  e['crates_back'],
                  e['crates_sold'],
                  e['returned_crates'],
                ]).toList(),
                fixedColCells: state.jsonList.map((e) => DateFormat('d MMM yy').format(e['date'].toDate())).toList(),
                fixedRowCells: [
                  "Line Name",
                  "Crates Sent",
                  "Crates Back",
                  "Crates Sold",
                  "Returned Crates",
                ],
              );
            } else {
              return const Center(child: Text('No Data Found'));
            }
          },
        ));
  }
}
