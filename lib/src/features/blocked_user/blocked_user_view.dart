import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/blocked_user/cubit/blocked_user_cubit.dart';
import 'package:goli_soda/src/features/shop_detail/shop_detail_view.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:goli_soda/src/utils/custom_search.dart';
import 'package:sizer/sizer.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({Key? key}) : super(key: key);

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {

  BlockedUserCubit? blockedUserCubit;

  @override
  void initState() {
    blockedUserCubit = BlocProvider.of<BlockedUserCubit>(context);
    blockedUserCubit!.getBlockedUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text('Blocked Users'),
      ),
      body: ListView(
        children: [
          search(),
          BlocBuilder<BlockedUserCubit, BlockedUserState>(
            builder: (context, state) {
              if(state is BlockedUserLoading) {
                return const Center(child: CircularProgressIndicator());
              }else if(state is BlockedUserSuccess){
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: state.jsonList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        bool reload = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShopDetailScreen(
                                        shopData:
                                        state.jsonList?[index]))) ??
                            false;
                        if (reload) {
                          // homeCubit!.getRegionCollectionData();
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(14.sp),
                          decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Colors.grey.withOpacity(0.1)
                                  : Colors.transparent),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (state.jsonList?[index]["shopName"] ??
                                        "unavailable")
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 4.sp,
                                  ),
                                  Text(
                                    state.jsonList?[index]["address"] ??
                                        "unavailable",
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lightColor),
                                  ),
                                ],
                              ),
                              (state.jsonList?[index]["is_blocked"] ??
                                  false)
                                  ? Icon(
                                Icons.block,
                                color: Colors.red,
                              )
                                  : Container(),
                            ],
                          )),
                    );
                  },
                );
              }else{
                return const Center(child: Text('No Data Found'));
              }

            },
          ),
        ],
      ),
    );
  }

  Widget search() {
    return SearchField(
      onChanged: (value) {
        if (value.length > 2) {
          blockedUserCubit!.getBlockedUser(keyword: value);
        } else if (value.isEmpty) {
          blockedUserCubit!.getBlockedUser();
        }
      },
    );
  }
}
