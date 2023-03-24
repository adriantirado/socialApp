import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_pet/screen/login_screen.dart';
import 'package:social_pet/reponsive/web_screen.dart';
import 'package:social_pet/reponsive/reponsive_screen.dart';
import 'package:social_pet/utils/colors.dart';
import 'package:social_pet/utils/global_variable.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  void gotoLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const ReponsiveLayout(
                mobileScreenLayout: LoginScreen(),
                webScreenLayout: WebScreen(),
              )),
    );
  }

  int _page = 0;
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

  void navigatioTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children:HomeScreemItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
         
    
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_a_photo,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2,
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigatioTapped,
      ),
    );
  }
}
