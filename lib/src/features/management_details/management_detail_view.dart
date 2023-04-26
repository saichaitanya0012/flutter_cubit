import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // final expenses = TextEditingController();
  DateTime? selectedDate;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> expenseTypes = [];
  List<num> expenseAmounts = [];
  List<GlobalKey<FormState>> _formKeys = [];

  void addExpense() {
    setState(() {
      expenseTypes.add('');
      expenseAmounts.add(0);
      _formKeys.add(GlobalKey<FormState>());
    });
  }

  void updateExpenseType(int index, String value) {
    setState(() {
      expenseTypes[index] = value;
    });
  }

  void updateExpenseAmount(int index, num value) {
    setState(() {
      expenseAmounts[index] = value;
    });
  }

  void removeExpense(int index) {
    setState(() {
      expenseTypes.removeAt(index);
      expenseAmounts.removeAt(index);
      _formKeys.removeAt(index);
    });
  }

  void saveDataToFirestore() {
    bool isFormValid = true;
    for (var formKey in _formKeys) {
      if (!formKey.currentState!.validate()) {
        isFormValid = false;
      }
    }

    if (!isFormValid) {
      return;
    }

    // Create a list of maps to store the entered details
    List<Map<String, dynamic>> expenses = [];
    for (int i = 0; i < expenseTypes.length; i++) {
      Map<String, dynamic> expense = {
        'type': expenseTypes[i],
        'amount': expenseAmounts[i],
      };
      expenses.add(expense);
    }

    // Create a map to store the list of expenses
    Map<String, dynamic> data = {
      'expenses': expenses,
    };

    // Update the Firestore document with the map
    FirebaseFirestore.instance
        .collection('your_collection_name')
        .doc('your_document_id')
        .update(data)
        .then((value) {
      print('Data updated successfully');
    }).catchError((error) {
      print('Failed to update data: $error');
    });
  }

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
        if (value.isNotEmpty) {
          lineCollection.text = value[0]['line_collection'];
          otherCollection.text = value[0]['other_collection'];
          totalCollection.text = value[0]['total_collection'];
          expenseTypes.clear();
          expenseAmounts.clear();
          _formKeys.clear();
          for(int i = 0; i < value[0]['expenses'].length; i++) {
            expenseTypes.add(value[0]['expenses'][i]['type']);
            expenseAmounts.add(value[0]['expenses'][i]['amount']);
            _formKeys.add(GlobalKey<FormState>());
          }
        } else {
          lineCollection.text = "";
          otherCollection.text = "";
          totalCollection.text = "";
          expenseTypes.clear();
          expenseAmounts.clear();
          _formKeys.clear();
          addExpense();
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
          Future.delayed(Duration(milliseconds: 100), () {
            if (state.isUpdate) {
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


                            bool isFormValid = true;
                            for (var formKey in _formKeys) {
                              if (!formKey.currentState!.validate()) {
                                isFormValid = false;
                              }
                            }

                            if (!isFormValid) {
                              return;
                            }

                            // Create a list of maps to store the entered details
                            List<Map<String, dynamic>> expenses = [];
                            for (int i = 0; i < expenseTypes.length; i++) {
                              Map<String, dynamic> expense = {
                                'type': expenseTypes[i],
                                'amount': expenseAmounts[i],
                              };
                              expenses.add(expense);
                            }

                            // Create a map to store the list of expenses
                            Map<String, dynamic> data = {
                              'expenses': expenses,
                            };
                            BlocProvider.of<ManagementDetailsCubit>(context)
                                .createProductionDetails(
                                    selectedDate!,
                                    lineCollection.text,
                                    otherCollection.text,
                                    (int.parse(lineCollection.text) +
                                            int.parse(otherCollection.text))
                                        .toString(),
                                    expenses);
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
                      label: "Other Collection : ",
                      controller: otherCollection,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
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
                    Text(
                      "Expenses : ",
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500),
                    ),

                    SizedBox(
                      height: 10.sp,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: expenseTypes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Form(
                            key: _formKeys[index],
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 01,
                                    ),
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(color: AppColors.whiteColor),
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
                                      filled: true,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Expense type is required';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => updateExpenseType(index, value),
                                    initialValue: expenseTypes[index],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 01,
                                    ),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(color: AppColors.whiteColor),
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
                                      filled: true,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Expense amount is required';
                                      } else if (num.tryParse(value) == null) {
                                        return "Invalid expense";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      if (value!.isNotEmpty) {
                                        updateExpenseAmount(index, num.parse(value));
                                      }
                                    },
                                    initialValue: expenseAmounts[index].toString(),
                                  ),
                                ),
                                index==0?SizedBox():IconButton(
                                  icon: Icon(Icons.remove,color: AppColors.whiteColor,  ),
                                  onPressed: () => removeExpense(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => addExpense(),
                          child: Text("Add Expense"),
                        ),
                      ],
                    ),
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
