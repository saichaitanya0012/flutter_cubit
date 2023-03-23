import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/production_details/cubit/prodution_details_cubit.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/custom_data_table.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DetailProduction extends StatefulWidget {
  const DetailProduction({Key? key}) : super(key: key);

  @override
  State<DetailProduction> createState() => _DetailProductionState();
}

class _DetailProductionState extends State<DetailProduction> {
  ProdutionDetailsCubit? produtionDetailsCubit;

  @override
  void initState() {
    produtionDetailsCubit = BlocProvider.of<ProdutionDetailsCubit>(context);
    produtionDetailsCubit!.getProductionDetails();
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
      body: BlocBuilder<ProdutionDetailsCubit, ProdutionDetailsState>(
        builder: (context, state) {
          if (state is ProdutionDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProdutionDetailsSuccess) {
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
                              e['crates_manufacture'],
                              e['crate_leakage'],
                              e['quality_inspection'],
                              e['total_crates'],
                              e['remarks'],
                            ])
                        .toList(),
                    fixedColCells: state.jsonList
                        .map((e) => DateFormat('d MMM yy').format(e['date'].toDate()))
                        .toList(),
                    fixedRowCells: [
                      "Crates Manufacture",
                      "Crate Leakage",
                      "Quailty Inspection",
                      "Total Crates",
                      "Remarks",
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
