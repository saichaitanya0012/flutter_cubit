import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/auth/widget/custom_textfield.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_cubit.dart';
import 'package:goli_soda/src/utils/common_snackbar.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';

class CreateVendorScreen extends StatefulWidget {
  final Map<dynamic, dynamic>? shopData;

  const CreateVendorScreen({Key? key, this.shopData}) : super(key: key);

  @override
  State<CreateVendorScreen> createState() => _CreateVendorScreenState();
}

class _CreateVendorScreenState extends State<CreateVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopOwnerNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _crateController = TextEditingController();

  @override
  void initState() {
    if (widget.shopData != null) {
      _shopNameController.text = widget.shopData!['shopName'];
      _shopOwnerNameController.text = widget.shopData!['ownerName'];
      _addressController.text = widget.shopData!['address'];
      _phoneController.text = widget.shopData!['phone'];
      _emailController.text = widget.shopData!['email'];
      _crateController.text = widget.shopData!['crate_price'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        title: Text('Add Shop'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: BlocBuilder<CreateVendorCubit, CreateVendorState>(
                  builder: (context, state) {
                    if (state is CreateVendorLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is CreateVendorInitial) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            controller: _shopNameController,
                            labelText: 'Shop Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a shop name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.sp),
                          CustomTextFormField(
                            controller: _shopOwnerNameController,
                            labelText: 'Owner Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a owner name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.sp),
                          CustomTextFormField(
                            controller: _addressController,
                            labelText: 'Address',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.sp),
                          CustomTextFormField(
                            controller: _phoneController,
                            labelText: 'Phone',
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.sp),
                          CustomTextFormField(
                            controller: _crateController,
                            labelText: 'Crate',
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an Crate Price';
                              }
                              return null;
                            },
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ),
          BlocBuilder<CreateVendorCubit, CreateVendorState>(
            builder: (context, state) {
              if (state is CreateVendorInitial) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(14.sp),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Perform the submit action here

                            if (widget.shopData != null) {
                              context
                                  .read<CreateVendorCubit>()
                                  .updateShopDetailsToFirestore(
                                    _shopNameController.text,
                                    _addressController.text,
                                    _phoneController.text,
                                    _shopOwnerNameController.text,
                                    _crateController.text,
                                    context,
                                    widget.shopData!['id'],
                                  );
                            } else {
                              final String shopName = _shopNameController.text;
                              final String address = _addressController.text;
                              final String phone = _phoneController.text;
                              final String email = _emailController.text;
                              final String ownerName = _shopOwnerNameController.text;
                              final String crate = _crateController.text;
                              // final num lineNumber = num.parse(_lineController.text);
                              context.read<CreateVendorCubit>().putShopDetailsToFirestore(
                                  shopName,
                                  address,
                                  phone,
                                  email,
                                  ownerName,
                                  crate,
                                  0,
                                  "",
                                  "",
                                  context);
                            }

                            // Do something with the shop details
                          } else {
                            CustomSnackBar()
                                .snackbarMessage(message: "Please fill all the fields");
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 30.sp,
                          decoration: BoxDecoration(
                            color: AppColors.blueColor,
                            borderRadius: BorderRadius.circular(100.sp),
                          ),
                          child: Center(
                              child: Text(
                            'SUBMIT',
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
