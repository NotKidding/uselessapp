// main.dart
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'time_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load();

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'TimeKey', 
        channelName: 'Time', 
        channelDescription: 'Notification Time',
      ),
    ],
    debug: true,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> timezones = [
    'America/New_York',
    'Europe/London',
    'Asia/Tokyo',
    'Australia/Sydney',
    'Africa/Cairo',
    'America/Los_Angeles',
    'Europe/Berlin',
    'Asia/Kolkata',
  ];

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> sendTimeNotification() async {
    try {
      final apiKey = dotenv.env['TIME_API_KEY'];
      if (apiKey == null) throw Exception('API key not found');

      final timeService = TimeService(apiKey);
      final randomTimezone = timezones[Random().nextInt(timezones.length)];
      
      final time = await timeService.getTime(randomTimezone);
      
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: Random().nextInt(100000),
          channelKey: 'TimeKey',
          title: time,
          body: 'Current time in $randomTimezone',
        ),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: sendTimeNotification,
            child: const Text('Send Time Notification'),
          ),
        ),
      ),
    );
  }
}