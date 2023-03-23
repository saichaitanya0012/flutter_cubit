import 'package:flutter/material.dart';
import 'package:goli_soda/src/features/get_lines/get_lines_view.dart';
import 'package:goli_soda/src/features/manager/manager_tabs.dart';
import 'package:goli_soda/src/features/profile/profile_screen.dart';
import 'package:goli_soda/src/features/total_history/total_history_screen.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';




class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>with SingleTickerProviderStateMixin{
  int _currentIndex = 0;
  TabController? _tabController;

  final List<Widget> _children = [
    GetLinesScreen(),
    TotalHistory(),
    ManagerTabs(),
    ProfileScreen()
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  //IndexedStack(
  //         index: _currentIndex,
  //         children:[
  //           HomeScreen(),
  //           TotalHistory(),
  //         ]
  //       ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          GetLinesScreen(),
          TotalHistory(),
          ManagerTabs(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryColor,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.primaryColor,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) {
            _tabController!.animateTo(index);
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: AppColors.primaryColor,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.primaryColor,
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.primaryColor,
              icon: Icon(Icons.margin),
              label: 'Manager',
            ),
            BottomNavigationBarItem(
              backgroundColor: AppColors.primaryColor,
              icon: Icon(Icons.face),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

}
