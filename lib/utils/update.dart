import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 检查更新
bool isUpdateAvailable(String currentVersion, String latestVersion) {
  // 解析版本号
  List<String> parseVersion(String version) {
    List<String> parts = version.split('-');
    String mainPart = parts[0];
    String? prereleasePart = parts.length > 1 ? parts[1] : null;

    List<String> mainSegments = mainPart.split('.');
    if (mainSegments.length != 3) {
      throw FormatException('Invalid version format: $version');
    }

    List<String> result = [...mainSegments];
    if (prereleasePart != null) {
      result.add(prereleasePart);
    }
    return result;
  }

  // 比较两个版本号
  int compareVersions(List<String> a, List<String> b) {
    // 比较主版本号
    for (int i = 0; i < 3; i++) {
      int aNum = int.parse(a[i]);
      int bNum = int.parse(b[i]);
      if (aNum != bNum) {
        return aNum.compareTo(bNum);
      }
    }

    // 处理预发布版本
    bool aHasPre = a.length > 3;
    bool bHasPre = b.length > 3;

    if (!aHasPre && !bHasPre) return 0; // 都没有预发布版本
    if (aHasPre && !bHasPre) return -1; // 当前版本是预发布，最新版本不是
    if (!aHasPre && bHasPre) return 1;  // 最新版本是预发布，当前版本不是

    // 比较预发布部分
    List<String> aPre = a[3].split('.');
    List<String> bPre = b[3].split('.');

    for (int i = 0;; i++) {
      if (i >= aPre.length && i >= bPre.length) return 0;
      if (i >= aPre.length) return -1;
      if (i >= bPre.length) return 1;

      String aElem = aPre[i];
      String bElem = bPre[i];

      bool aIsNum = int.tryParse(aElem) != null;
      bool bIsNum = int.tryParse(bElem) != null;

      if (aIsNum && bIsNum) {
        int aNum = int.parse(aElem);
        int bNum = int.parse(bElem);
        if (aNum != bNum) return aNum.compareTo(bNum);
      } else if (aIsNum) {
        return -1;
      } else if (bIsNum) {
        return 1;
      } else {
        int compare = aElem.compareTo(bElem);
        if (compare != 0) return compare;
      }
    }
  }

  try {
    List<String> current = parseVersion(currentVersion);
    List<String> latest = parseVersion(latestVersion);
    return compareVersions(current, latest) < 0;
  } catch (e) {
    throw ArgumentError('Invalid version format: $e');
  }
}

// 检查权限
Future<bool> checkPermission(Permission permission) async {
  if (Platform.isAndroid) {
    var status = await permission.status;
    if (!status.isGranted) {
      // 申请权限
      await permission.request();
      // 重新获取权限状态
      var newStatus = await permission.status;
      if (newStatus.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
}

// 通知服务
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