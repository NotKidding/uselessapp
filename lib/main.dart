import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

void main() {
  AwesomeNotifications().initialize(
    null,//icon
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
@override
void initState(){
  AwesomeNotifications().isNotificationAllowed().then((isAllowed){
    if(!isAllowed){
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  super.initState();
}

void triggerNotification(){
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'TimeKey',
      title: 'Simple Notification',
      body: 'Notification Body'

    )
  );
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
        ),
        body:  Center(
          child: ElevatedButton(
            onPressed: triggerNotification, 
            child: const Text('Trigger Notification')),
        ),
      ),
    );
  }
}
