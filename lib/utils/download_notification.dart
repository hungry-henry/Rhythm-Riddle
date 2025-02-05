import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///下载通知栏
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
  }) async {
    if(!Platform.isAndroid && !Platform.isIOS) return;
    AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel', // 通知频道ID
      'Downloads', // 通知频道名称
      channelDescription: 'Shows download progress, and make sure not to be killed by system.',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: null,
    );
  }

  static Future<void> cancelNotification(int id) async {
    if(!Platform.isAndroid && !Platform.isIOS) return;
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAll() async{
    if(!Platform.isAndroid && !Platform.isIOS) return;
    await _notificationsPlugin.cancelAll();
  }
}