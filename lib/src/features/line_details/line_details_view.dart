import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_cubit.dart';
import 'package:goli_soda/src/features/get_lines/get_lines_view.dart';
import 'package:goli_soda/src/features/line_details/cubits/line_details_cubit.dart';
import 'package:goli_soda/src/features/production_details/widget/custom_textfield.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/navigation.dart';
import 'package:sizer/sizer.dart';

class LineDetails extends StatefulWidget {
  const LineDetails({Key? key}) : super(key: key);

  @override
  State<LineDetails> createState() => _LineDetailsState();
}

class _LineDetailsState extends State<LineDetails> {
  final crateSent = TextEditingController();
  final crateBack = TextEditingController();
  final returnCrate = TextEditingController();
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
      BlocProvider.of<LineDetailsCubit>(context)
          .getLineDetailsBasedOnDate(picked)
          .then((value) {
        if (value.isNotEmpty) {
          crateSent.text = value[0]['crateSent'];
          crateBack.text = value[0]['crateBack'];
          returnCrate.text = value[0]['returnCrate'];
        } else {
          crateSent.text = "";
          crateBack.text = "";
          returnCrate.text = "";
        }
      });
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LineDetailsCubit, LineDetailsState>(
      listener: (context, state) {
        if (state is LineDetailsInitial) {
          Future.delayed(Duration(seconds: 0), () {
            if (state.isUpdate) {
              CustomSnackBar()
                  .snackbarMessage(message: "Line Details Added Successfully");
              Navigator.pop(context);
            }
          });
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LineDetailsLoading) {
          return Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LineDetailsInitial) {
          return Scaffold(
            backgroundColor: AppColors.primaryColor,
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              title: const Text('Line Details'),
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
                    child: BlocBuilder<CreateVendorCubit, CreateVendorState>(
                      builder: (context, state1) {
                        return InkWell(
                          onTap: () {
                            if (state1 is CreateVendorInitial) {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                if (selectedDate == null) {
                                  CustomSnackBar()
                                      .snackbarMessage(message: "Please Select Date");
                                  return;
                                } else if (state1.name == null || state1.id == null) {
                                  CustomSnackBar()
                                      .snackbarMessage(message: "Please Select Line");
                                } else {
                                  BlocProvider.of<LineDetailsCubit>(context)
                                      .createLineDetails(
                                          selectedDate!,
                                          crateSent.text,
                                          crateBack.text,
                                          (int.parse(crateSent.text) -
                                                  int.parse(crateBack.text))
                                              .toString(),
                                          returnCrate.text,
                                          state1.name!,
                                          state1.id!);
                                }
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
                        );
                      },
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
                    BlocBuilder<CreateVendorCubit, CreateVendorState>(
                      builder: (context, state) {
                        if (state is CreateVendorInitial) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Line : ",
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  state.id != null
                                      ? Row(
                                          children: [
                                            SizedBox(height: 10.0),
                                            Text(
                                              (state.name ?? "unavailable")
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<CreateVendorCubit>()
                                                        .emit(CreateVendorInitial());
                                                  },
                                                  icon: Icon(
                                                    Icons.clear,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                nextScreen(
                                                    context,
                                                    GetLinesScreen(
                                                      isSearch: true,
                                                    ));
                                              },
                                              child: Text(
                                                '+ Add Line',
                                                style: TextStyle(
                                                  color: AppColors.whiteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Center(
                              child: Text(
                            'Please wait...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ));
                        }
                      },
                    ),
                    CustomFormField(
                      label: "Crates sent : ",
                      controller: crateSent,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
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
                      label: "Crates back : ",
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: crateBack,
                      onChanged: (value) {
                        if (value!.isNotEmpty) {
                          setState(() {});
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter crates leakage";
                        }
                        return null;
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
                                "Crates Sold : ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                (int.parse(crateSent.text.isEmpty
                                            ? "0"
                                            : crateSent.text) -
                                        int.parse(crateBack.text.isEmpty
                                            ? "0"
                                            : crateBack.text))
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
                      label: " Returned Crates : ",
                      controller: returnCrate,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter crates";
                        }
                        return null;
                      },
                    ),
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
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        }
      },
    );
  }
}
