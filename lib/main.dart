import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Screens/login_screen.dart';
import 'package:insta_clone/Screens/notification_screen.dart';
import 'package:insta_clone/providers/User_providers.dart';
import 'package:insta_clone/resources/Notifiaction_Services.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Background notification handler
Future<void> bgNotificationHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print("Message received in background: ${message.notification?.title}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCEA7-VO1nJ8HjuxEMInvCMFJCzN2095fQ",
        appId: "1:279670175316:web:20e83d240b4b92f215dfc1",
        messagingSenderId: "279670175316",
        projectId: "insta-clone-906b7",
        storageBucket: "insta-clone-906b7.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Request notification permissions
  await FirebaseMessaging.instance.requestPermission();

  // Initialize local notifications for non-web platforms
  if (!kIsWeb) {
    await PushNotifications.localNotiInit();
  }

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(bgNotificationHandler);

  // Handle app launched from a notification (terminated state)
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState?.pushNamed("/message", arguments: initialMessage);
    });
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        routes: {
          '/': (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return const ResponsiveLayout(
                        webScreenLayout: WebScreenLayout(),
                        mobileScreenLayout: MobileScreenLayout(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                  return const LoginScreen();
                },
              ),
          '/message': (context) => const NotificationScreen(),
        },
      ),
    );
  }
}
