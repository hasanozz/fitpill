// notification_service.dart

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// 🚨 Düzeltme: Doğru paket adı FlutterTimezone
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// WeeklyRoutineState ve WeeklyRoutineModels içindeki Weekday'in tanımlı olduğu yerler:
import 'package:fitpill/features/main_tabs/home/weekly_routine/weekly_routine_models.dart';


class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static bool _timeZoneConfigured = false;

  static const String _routineChannelId = 'weekly_routine_reminders';
  static const String _pushChannelId = 'fitpill_updates';

  static const String _routineChannelName = 'Weekly routine reminders';
  static const String _pushChannelName = 'Fitpill notifications';


  static const int _routineNotificationBaseId = 4000;
  static const int _pushNotificationBaseId = 9000;
  static const int _defaultReminderHour = 9;
  static const int _defaultReminderMinute = 0;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _configureLocalTimeZone();
    await _notificationsPlugin.initialize(
      settings,
    );
    _initialized = true;

    await _ensurePermissions();
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      handleRemoteMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleRemoteMessage(message);
    });
  }

  static Future<void> handleRemoteMessage(RemoteMessage message) async {
    if (!_initialized) {
      await initialize();
    }
    // ... (Aynı kalır)
    final notification = message.notification;
    if (notification == null) {
      return;
    }

    final title = notification.title;
    final body = notification.body;
    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    await _notificationsPlugin.show(
      _pushNotificationBaseId + DateTime.now().millisecondsSinceEpoch % 1000,
      title,
      body,
      _notificationDetails(channel: _pushChannelId),
    );
  }

  // 🚨 Düzeltme: Çeviri nesnesi (S strings) artık parametre olarak alınıyor.
  static Future<void> syncRoutineSchedule({
    required WeeklyRoutineState routine,
    required String Function(String) translateWorkout, // Çeviri fonksiyonu alıyor
    required String Function() translateTitle,         // Başlık çeviri fonksiyonu alıyor // Çeviri nesnesini dışarıdan alıyoruz
  }) async {
    await initialize();

    await _configureLocalTimeZone();

    for (final entry in routine.entries.values) {
      final notificationId = _routineNotificationBaseId + entry.day.index;
      if (entry.selection != null && !entry.isOffDay) {

        final scheduledDate = _nextInstanceOfWeekday(
          entry.day,
          hour: _defaultReminderHour,
          minute: _defaultReminderMinute,
        );

        // translateWorkout fonksiyonu kullanılarak çeviri yapılıyor
        final body =
        translateWorkout(entry.selection!.title);

        await _notificationsPlugin.cancel(notificationId);

        await _notificationsPlugin.zonedSchedule(
          notificationId,
          translateTitle(), // Başlık çeviri fonksiyonu kullanılıyor
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          _notificationDetails(channel: _routineChannelId),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      } else {
        await _notificationsPlugin.cancel(notificationId);
      }
    }
  }

  static NotificationDetails _notificationDetails({required String channel}) {
    // ... (Aynı kalır)
    final isRoutineChannel = channel == _routineChannelId;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel,
        isRoutineChannel ? _routineChannelName : _pushChannelName,
        channelDescription: isRoutineChannel
            ? 'Reminds you about your planned Fitpill workouts.'
            : 'General updates and announcements from Fitpill.',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static Future<void> _ensurePermissions() async {
    // ... (Aynı kalır)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  static DateTime _nextInstanceOfWeekday(
      Weekday day, {
        required int hour,
        required int minute,
      }) {
    // ... (Aynı kalır)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    final weekdayIndex = _weekdayToDateTime(day);
    final daysDifference = (weekdayIndex - now.weekday) % 7;
    var scheduled = today.add(Duration(days: daysDifference));

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    return scheduled;
  }

  static int _weekdayToDateTime(Weekday day) {
    return day.index + DateTime.monday;
  }

  static Future<void> _configureLocalTimeZone() async {
    if (_timeZoneConfigured) {
      return;
    }

    tz.initializeTimeZones();
    try {
      // 🚨 Düzeltme: FlutterNativeTimezone yerine FlutterTimezone kullanılır
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName as String));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    _timeZoneConfigured = true;
  }
}