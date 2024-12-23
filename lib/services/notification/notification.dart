import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();
  static bool _initialized = false;

  // Notification channels
  static const String _mainChannelId = 'main_channel';
  static const String _scheduleChannelId = 'schedule_channel';
  static const String _alertChannelId = 'alert_channel';

  // Initialize the local notifications
  static Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Configure platform specific settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
  
      linux: initializationSettingsLinux,
    );

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }

    _initialized = true;
    
    // Request permissions after initialization
    await requestPermissions();
  }

  // Create notification channels for Android
  static Future<void> _createNotificationChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = 
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _mainChannelId,
        'Main Channel',
        description: 'Main channel for general notifications',
        importance: Importance.high,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _scheduleChannelId,
        'Scheduled Notifications',
        description: 'Channel for scheduled notifications',
        importance: Importance.high,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _alertChannelId,
        'Alert Notifications',
        description: 'Channel for urgent notifications',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
        enableVibration: true,
      ),
    );
  }

  // Handle tap on notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null && 
        notificationResponse.payload!.isNotEmpty) {
      onClickNotification.add(notificationResponse.payload!);
    }
  }

  // Request notification permissions
  static Future<bool> requestPermissions() async {
    try {
      if (Platform.isIOS) {
        final bool? result = await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        return result ?? false;
      } else if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        if (status.isPermanentlyDenied) {
          print('Notifications permanently denied. Opening settings...');
          await openAppSettings();
          return false;
        }
        return status.isGranted;
      }
      return false;
    } catch (e) {
      print('Error requesting notification permissions: $e');
      return false;
    }
  }

  // Show immediate notification
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    bool isAlert = false,
  }) async {
    try {
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          isAlert ? _alertChannelId : _mainChannelId,
          isAlert ? 'Alert Notifications' : 'Main Channel',
          channelDescription: 
              isAlert ? 'Channel for urgent notifications' : 
                       'Main channel for general notifications',
          importance: isAlert ? Importance.max : Importance.high,
          priority: isAlert ? Priority.max : Priority.high,
          enableVibration: isAlert,
          enableLights: isAlert,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  // Schedule a notification
  static Future<void> showScheduledNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          _scheduleChannelId,
          'Scheduled Notifications',
          channelDescription: 'Channel for scheduled notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        DateTime.now().millisecond,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // Show periodic notification
  static Future<void> showPeriodicNotification({
    required String title,
    required String body,
    required RepeatInterval interval,
    String? payload,
  }) async {
    try {
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          _mainChannelId,
          'Main Channel',
          channelDescription: 'Main channel for general notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

      await _flutterLocalNotificationsPlugin.periodicallyShow(
        DateTime.now().millisecond,
        title,
        body,
        interval,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      print('Error showing periodic notification: $e');
    }
  }

  // Check notification permissions
  static Future<bool> checkPermissions() async {
    if (Platform.isAndroid) {
      final bool? granted = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return granted ?? false;
    } else if (Platform.isIOS) {
      return await Permission.notification.isGranted;
    }
    return false;
  }

  // Cancel a specific notification
  static Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Dispose resources
  static void dispose() {
    onClickNotification.close();
  }
  static Future<void> initializeExpenseNotifications() async {
    // First ensure notifications are initialized
    await init();
    
    // Cancel any existing periodic notifications
    await cancelAll();
    
    // Show initial notification
    await showNotification(
      title: 'Expense Tracking Active',
      body: 'Your expense tracking is now active. You\'ll receive regular updates.',
      isAlert: false,
    );
    
    // Set up periodic notification
    await showPeriodicNotification(
      title: 'Expense Reminder',
      body: 'Remember to track your expenses! Stay on top of your financial goals.',
      interval: RepeatInterval.everyMinute,
      payload: 'expense_reminder',
    );
  }
}