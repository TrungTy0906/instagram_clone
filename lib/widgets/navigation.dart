import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/main.dart';
import 'package:instagram/screens/add_screen.dart';
import 'package:instagram/screens/explore.dart';
import 'package:instagram/screens/explore_screen.dart';
import 'package:instagram/screens/home.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/reel_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            onTap: navigationTapped,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.camera), label: ''),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/instagram-reels-icon.png',
                    height: 18.h,
                  ),
                  label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: ''),
            ]),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          HomeScreen(),
          ExploreScreen(),
          AddScreen(),
          ReelScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
