import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<double> preferensiKetebalan = ValueNotifier(0.0);
final ValueNotifier<int> preferensiBatasHarian = ValueNotifier<int>(500000);
final ValueNotifier<int> preferensiUangMakanHarian = ValueNotifier<int>(20000);

Future<void> muatPengaturan() async {
  final prefs = await SharedPreferences.getInstance();
  preferensiKetebalan.value = prefs.getDouble('ketebalan_glass') ?? 0.0;
  preferensiBatasHarian.value = prefs.getInt('batas_harian') ?? 500000;
  preferensiUangMakanHarian.value = prefs.getInt('uang_makan_harian') ?? 20000;
}

Future<void> simpanKetebalan(double nilai) async {
  preferensiKetebalan.value = nilai;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('ketebalan_glass', nilai);
}

Future<void> simpanBatasHarian(int nilai) async {
  preferensiBatasHarian.value = nilai;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('batas_harian', nilai);
}

Future<void> simpanUangMakanHarian(int nilai) async {
  preferensiUangMakanHarian.value = nilai;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('uang_makan_harian', nilai);
}