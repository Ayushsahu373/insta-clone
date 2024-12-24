import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map<String, dynamic>? payload;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;

    if (data is RemoteMessage) {
      setState(() {
        payload = data.data;
      });
    }

    return Scaffold(
      body: Center(
        child: payload != null
            ? Text('The data is: ${payload.toString()}')
            : const Text('No notification data available'),
      ),
    );
  }
}
