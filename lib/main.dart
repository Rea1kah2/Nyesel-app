import 'package:flutter/material.dart';
import 'nyesel/nyesel_home.dart';
import 'nyesel/reminder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initReminder();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyesel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A1F),
        useMaterial3: true,
      ),
      home: const NyeselHome(),
    );
  }
}
