// // Add to pubspec.yaml:
// // shared_preferences: ^2.2.2

// import 'package:FinFlow/notification/notification.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:notification_listener_service/notification_listener_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificationPermissionHandler {
//   static const String PREF_NOTIFICATIONS_ENABLED = 'notifications_enabled';
//   static const String PREF_PAYMENT_TRACKING_ENABLED = 'payment_tracking_enabled';
  
//   static Future<bool> requestNotificationPermissions(BuildContext context) async {
//     bool granted = false;
    
//     // Show permission dialog
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Enable Notifications'),
//           content: const Text(
//             'Would you like to receive daily reminders and payment notifications to help track your expenses?'
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Not Now'),
//               onPressed: () {
//                 granted = false;
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Enable'),
//               onPressed: () async {
//                 // Request system permissions
//                 final notificationSettings = await NotificationService()
//                     .flutterLocalNotificationsPlugin
//                     .resolvePlatformSpecificImplementation<
//                         AndroidFlutterLocalNotificationsPlugin>()
//                     ?.requestNotificationsPermission();
                    
//                 final paymentPermission = await NotificationListenerService
//                     .requestPermission();
                
//                 granted = notificationSettings ?? false;
                
//                 // Save user preference
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.setBool(PREF_NOTIFICATIONS_ENABLED, granted);
//                 await prefs.setBool(PREF_PAYMENT_TRACKING_ENABLED, 
//                     paymentPermission);
                
//                 if (granted) {
//                   await NotificationService().schedulePeriodicReminder();
//                 }
                
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
    
//     return granted;
//   }
// }

// class NotificationSettingsPage extends StatefulWidget {
//   const NotificationSettingsPage({Key? key}) : super(key: key);

//   @override
//   State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
// }

// class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
//   bool _notificationsEnabled = false;
//   bool _paymentTrackingEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadSettings();
//   }

//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _notificationsEnabled = prefs.getBool(
//           NotificationPermissionHandler.PREF_NOTIFICATIONS_ENABLED) ?? false;
//       _paymentTrackingEnabled = prefs.getBool(
//           NotificationPermissionHandler.PREF_PAYMENT_TRACKING_ENABLED) ?? false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification Settings'),
//       ),
//       body: ListView(
//         children: [
//           SwitchListTile(
//             title: const Text('Daily Reminders'),
//             subtitle: const Text('Receive daily reminders to update expenses'),
//             value: _notificationsEnabled,
//             onChanged: (bool value) async {
//               if (value) {
//                 final granted = await NotificationService()
//                     .flutterLocalNotificationsPlugin
//                     .resolvePlatformSpecificImplementation<
//                         AndroidFlutterLocalNotificationsPlugin>()
//                     ?.requestNotificationsPermission();
                    
//                 if (granted ?? false) {
//                   await NotificationService().schedulePeriodicReminder();
//                 }
//                 value = granted ?? false;
//               } else {
//                 await NotificationService()
//                     .flutterLocalNotificationsPlugin.cancelAll();
//               }
              
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setBool(
//                   NotificationPermissionHandler.PREF_NOTIFICATIONS_ENABLED, value);
              
//               setState(() {
//                 _notificationsEnabled = value;
//               });
//             },
//           ),
//           SwitchListTile(
//             title: const Text('Payment Tracking'),
//             subtitle: const Text('Get notified to add expenses after UPI payments'),
//             value: _paymentTrackingEnabled,
//             onChanged: (bool value) async {
//               if (value) {
//                 value = await NotificationListenerService.requestPermission();
//               }
              
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setBool(
//                   NotificationPermissionHandler.PREF_PAYMENT_TRACKING_ENABLED, 
//                   value);
              
//               setState(() {
//                 _paymentTrackingEnabled = value;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }