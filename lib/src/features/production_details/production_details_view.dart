import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/production_details/cubit/prodution_details_cubit.dart';
import 'package:goli_soda/src/features/production_details/widget/custom_textfield.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';

class ProductionDetailsScreen extends StatefulWidget {
  const ProductionDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductionDetailsScreen> createState() => _ProductionDetailsScreenState();
}

class _ProductionDetailsScreenState extends State<ProductionDetailsScreen> {
  final cratesManufacture = TextEditingController();
  final crateLeakage = TextEditingController();
  final qualityInspection = TextEditingController();

  // final crate = TextEditingController();
  final remarks = TextEditingController();
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
      BlocProvider.of<ProdutionDetailsCubit>(context)
          .getProductionDetailsBasedOnDate(picked)
          .then((value) {
        if (value.isNotEmpty) {
          cratesManufacture.text = value[0]['crates_manufacture'];
          crateLeakage.text = value[0]['crate_leakage'];
          qualityInspection.text = value[0]['quality_inspection'];
          remarks.text = value[0]['remarks'];
        } else {
          cratesManufacture.text = "";
          crateLeakage.text = "";
          qualityInspection.text = "";
          remarks.text = "";
        }
      });
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text('Production Details'),
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
                      CustomSnackBar().snackbarMessage(message: "Please Select Date");
                      return;
                    } else {
                      BlocProvider.of<ProdutionDetailsCubit>(context)
                          .createProductionDetails(
                              selectedDate!,
                              cratesManufacture.text,
                              crateLeakage.text,
                              qualityInspection.text,
                              (int.parse(cratesManufacture.text) -
                                      int.parse(crateLeakage.text) -
                                      int.parse(qualityInspection.text))
                                  .toString(),
                              remarks.text);
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
      body: BlocConsumer<ProdutionDetailsCubit, ProdutionDetailsState>(
        listener: (context, state) {
          if (state is ProdutionDetailsInitial) {
            Future.delayed(Duration(seconds: 0), () {
              if (state.isUpdate) {
                CustomSnackBar()
                    .snackbarMessage(message: "Production Details Added Successfully");
                Navigator.pop(context);
              }
            });
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is ProdutionDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProdutionDetailsInitial) {
            return Form(
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
                      label: "Crates Manufacture : ",
                      controller: cratesManufacture,
                      onChanged: (value) {
                        if (value!.isNotEmpty) {
                          setState(() {});
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter crates manufacture";
                        }
                        return null;
                      },
                    ),
                    CustomFormField(
                      label: "Crates Leakage : ",
                      controller: crateLeakage,
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
                    CustomFormField(
                      label: "Quality Inspection : ",
                      controller: qualityInspection,
                      onChanged: (value) {
                        if (value!.isNotEmpty) {
                          setState(() {});
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter crates";
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
                                "Total Crates : ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                (int.parse(cratesManufacture.text.isNotEmpty
                                            ? cratesManufacture.text
                                            : "0") -
                                        int.parse(crateLeakage.text.isNotEmpty
                                            ? crateLeakage.text
                                            : "0") -
                                        int.parse(qualityInspection.text.isNotEmpty
                                            ? qualityInspection.text
                                            : "0"))
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
                    Divider(),
                    Text(
                      "Remarks : ",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 4.sp,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: remarks,
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter remarks";
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 01,
                          ),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Enter your remarks...',
                            // border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: AppColors.whiteColor, fontSize: 10.sp),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppColors.lightColor,
                                width: 2,
                                strokeAlign: StrokeAlign.inside,
                                style: BorderStyle.solid,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: AppColors.semiBlueColor,
                                width: 2,
                                strokeAlign: StrokeAlign.inside,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text("Something went wrong"),
            );
          }
        },
      ),
    );
  }
}
