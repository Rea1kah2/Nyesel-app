import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

final FlutterLocalNotificationsPlugin _notifikasiPlugin =
    FlutterLocalNotificationsPlugin();

const int _idReminderHarian = 1;

Future<void> initReminder() async {
  tz_data.initializeTimeZones();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();

  await _notifikasiPlugin.initialize(
    const InitializationSettings(android: androidSettings, iOS: iosSettings),
  );

  final diizinkan = await _notifikasiPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  debugPrint('Izin notifikasi: $diizinkan');
}

Future<void> jadwalkanReminderHarian() async {
  final sekarang = tz.TZDateTime.now(tz.local);
  var jadwal = tz.TZDateTime(
      tz.local, sekarang.year, sekarang.month, sekarang.day, 20, 00);

  if (jadwal.isBefore(sekarang)) {
    jadwal = jadwal.add(const Duration(days: 1));
  }

  await _notifikasiPlugin.zonedSchedule(
    _idReminderHarian,
    'Udah nyatet pengeluaran hari ini?',
    'Jangan sampai ada yang disesali tapi kelupaan catet.',
    jadwal,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_harian',
        'Reminder Harian',
        channelDescription: 'Pengingat untuk mencatat pengeluaran harian',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> tampilkanNotifikasiUji() async {
  await _notifikasiPlugin.show(
    0,
    'Notifikasi Uji',
    'Kamu akan diingatkan jam 20.00 tiap hari untuk mencatat pengeluaranmu.',
    const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_harian',
          'Reminder Harian',
          channelDescription: 'Pengingat untuk mencatat pengeluaran harian',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails()),
  );
}

Future<void> batalkanReminder() async {
  await _notifikasiPlugin.cancel(_idReminderHarian);
}
