import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:safetycare/theme.dart';
import 'package:safetycare/widget/contact.dart';
import 'package:safetycare/widget/history.dart';
import 'package:safetycare/widget/home.dart';
import 'package:safetycare/widget/settings.dart';

class BottomNavBarNavigator extends StatefulWidget {
  const BottomNavBarNavigator({Key? key}) : super(key: key);
  @override
  _BottomNavBarNavigatorState createState() => _BottomNavBarNavigatorState();
}

class _BottomNavBarNavigatorState extends State<BottomNavBarNavigator> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  static List _widgetOptions = [
    HomePage(),
    // ContactsMainPage(key: PageStorageKey('contacts-main-page'), title: 'Flutter Contacts',),
    ContactPage(),
    // Hitory(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: themeColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            backgroundColor: Colors.transparent,
            activeColor: Colors.white,
            color: Colors.white,
            // add gradient color for the tab background
            tabBackgroundColor: lighterBgColor,
            gap: 8,
            padding: EdgeInsets.all(10),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                textStyle: themeFontFamily.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              GButton(
                icon: Icons.contact_emergency,
                text: 'Contacts',
                textStyle: themeFontFamily.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              // GButton(
              //   icon: Icons.history,
              //   text: 'History',
              //   textStyle: themeFontFamily.copyWith(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: textColor,
              //   ),
              // ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                textStyle: themeFontFamily.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              print(index);
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
