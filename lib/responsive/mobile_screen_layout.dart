import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Screens/Profile_screen.dart';
import 'package:insta_clone/Screens/Search_Screen.dart';
import 'package:insta_clone/Screens/add_post_screen.dart';
import 'package:insta_clone/Screens/feed_screen.dart';
import 'package:insta_clone/Screens/notification_screen.dart';
import 'package:insta_clone/providers/User_providers.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  _MobileScreenLayoutState createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0; // Track selected index

  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: PageView(
        children: [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          NotificationScreen(),
          userProvider.getUser != null
              ? ProfileScreen(uid: userProvider.getUser!.uid.toString())
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChange,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        items: <Widget>[
          Icon(Icons.home,
              size: 30, color: _page == 0 ? instagramPinkColor : Colors.grey),
          Icon(Icons.search,
              size: 30, color: _page == 1 ? instagramPinkColor : Colors.grey),
          Icon(Icons.add_circle_outline,
              size: 30, color: _page == 2 ? instagramPinkColor : Colors.grey),
          Icon(Icons.favorite_outlined,
              size: 30, color: _page == 3 ? instagramPinkColor : Colors.grey),
          Icon(
            Icons.person,
            size: 30,
            color: _page == 4 ? instagramPinkColor : Colors.grey,
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: instagramOrangeColor,
        animationCurve: Curves.linear,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
            navigationTapped(_page);
          });
        },
      ),
    );
  }
}
