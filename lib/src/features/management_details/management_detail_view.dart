import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/management_details/cubit/management_details_cubit.dart';
import 'package:goli_soda/src/features/management_details/cubit/management_details_cubit.dart';
import 'package:goli_soda/src/features/production_details/widget/custom_textfield.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';

class ManagementDetailsScreen extends StatefulWidget {
  const ManagementDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ManagementDetailsScreen> createState() => _ManagementDetailsScreenState();
}

class _ManagementDetailsScreenState extends State<ManagementDetailsScreen> {
  final lineCollection = TextEditingController();
  final otherCollection = TextEditingController();
  final totalCollection = TextEditingController();
  final expenses = TextEditingController();
  DateTime? selectedDate;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppColors.primaryColor,
              accentColor: AppColors.primaryColor,
              colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        firstDate: DateTime(2023, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      BlocProvider.of<ManagementDetailsCubit>(context)
          .getManagementDetailsBasedOnDate(picked)
          .then((value) {
        if (value.isEmpty) {
          lineCollection.text = value[0]['line_collection'];
          otherCollection.text = value[0]['other_collection'];
          totalCollection.text = value[0]['total_collection'];
          expenses.text = value[0]['expenses'];
        } else {
          lineCollection.text = "";
          otherCollection.text = "";
          totalCollection.text = "";
          expenses.text = "";
        }
      });

      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagementDetailsCubit, ManagementDetailsState>(
      listener: (context, state) {
        if (state is ManagementDetailsInitial) {
          Future.delayed(Duration(seconds: 0),(){
            if(state.isUpdate){
              CustomSnackBar()
                  .snackbarMessage(message: "Management Details Added Successfully");
              Navigator.pop(context);
            }
          });
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ManagementDetailsLoading) {
          return Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ManagementDetailsInitial) {
          return Scaffold(
            backgroundColor: AppColors.primaryColor,
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
              title: const Text('Management Details'),
              actions: [
                IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: Icon(Icons.calendar_today))
              ],
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(14.sp),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (selectedDate == null) {
                            CustomSnackBar()
                                .snackbarMessage(message: "Please Select Date");
                            return;
                          } else {
                            BlocProvider.of<ManagementDetailsCubit>(context)
                                .createProductionDetails(
                                    selectedDate!,
                                    lineCollection.text,
                                    otherCollection.text,
                                    (int.parse(lineCollection.text) +
                                            int.parse(otherCollection.text))
                                        .toString(),
                                    expenses.text);
                          }
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 30.sp,
                        decoration: BoxDecoration(
                          color: AppColors.blueColor,
                          borderRadius: BorderRadius.circular(100.sp),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightColor,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(14.sp),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Date : ",
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            selectedDate == null
                                ? "----"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    CustomFormField(
                      label: "Line Collection : ",
                      controller: lineCollection,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter crates manufacture";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value!.isNotEmpty) {
                          setState(() {});
                        }
                      },
                    ),
                    CustomFormField(
                      label: "Other Collection : ",
                      controller: otherCollection,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter crates leakage";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value!.isNotEmpty) {
                          setState(() {});
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.sp),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Total Collection : ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                (int.parse(lineCollection.text.isEmpty
                                            ? "0"
                                            : lineCollection.text) +
                                        int.parse(otherCollection.text.isEmpty
                                            ? "0"
                                            : otherCollection.text))
                                    .toString(),
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    CustomFormField(
                      label: "Expenses : ",
                      controller: expenses,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter crates";
                        }
                        return null;
                      },
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsets.only(bottom: 4.sp),
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: [
                    //           Text(
                    //             "Total Crates : ",
                    //             style: TextStyle(
                    //                 color: Colors.grey,
                    //                 fontSize: 8.sp,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //           Text(
                    //             "100",
                    //             style: TextStyle(
                    //                 color: AppColors.whiteColor,
                    //                 fontSize: 14.sp,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Divider(),
                    // Text(
                    //   "Remarks : ",
                    //   style: TextStyle(
                    //       color: AppColors.whiteColor, fontSize: 8.sp, fontWeight: FontWeight.w500),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(
                    //     top: 4.sp,
                    //   ),
                    //   // width: 70.sp,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: AppColors.whiteColor.withOpacity(0.2),
                    //         blurRadius: 2,
                    //         spreadRadius: 0,
                    //         offset: Offset(0, 0),
                    //       ),
                    //     ],
                    //   ),
                    //
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: TextFormField(
                    //       controller: remarks,
                    //       maxLines: 3,
                    //       validator: (value) {
                    //         if (value!.isEmpty) {
                    //           return "Please enter remarks";
                    //         }
                    //         return null;
                    //       },
                    //       keyboardType: TextInputType.multiline,
                    //       decoration: InputDecoration(
                    //         hintText: 'Enter your remarks...',
                    //         border: InputBorder.none,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        }
      },
    );
  }
}
