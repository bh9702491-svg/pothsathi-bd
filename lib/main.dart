import 'package:flutter/material.dart';

import 'core/db/app_database.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AppDatabase.instance; // প্রথমবার চালুতে ডাটাবেস তৈরি হয়
  } catch (e) {
    debugPrint('ডাটাবেস চালু করা যায়নি: $e');
  }
  runApp(const PothSathiApp());
}

class PothSathiApp extends StatelessWidget {
  const PothSathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'পথসাথী BD',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}
