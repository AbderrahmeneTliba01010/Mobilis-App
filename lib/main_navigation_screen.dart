import 'package:flutter/material.dart';
import 'package:mobilis/screens/home/home_screen.dart';
import 'package:mobilis/screens/messages/conversation_screen.dart';
import 'package:mobilis/screens/point_of_sale/point_of_sale_screen.dart';
import 'package:mobilis/screens/prospecting/prospecting_screen.dart';
import 'package:mobilis/screens/route_planning/route_planning_screen.dart';
import 'package:mobilis/screens/settings/settings_screen.dart';
import 'package:mobilis/screens/territory/territory_screen.dart';

import '../../theme/app_colors.dart';
import '../../theme/text_styles.dart';



class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomeScreen(),
    TerritoryScreen(),
    RoutePlanningScreen(),
    PointsOfSaleScreen(),
    ProspectingScreen(),
    MessagesListScreen(),
    SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Territory Map'),
    BottomNavigationBarItem(icon: Icon(Icons.alt_route), label: 'Routes'),
    BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Points of Sale'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Prospecting'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTextStyles.body,
        unselectedLabelStyle: AppTextStyles.bodySmall,
        showUnselectedLabels: true,
        elevation: 8,
      ),
    );
  }
}
