import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'view/auth/registration_screen.dart';

late Box box;
void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'validation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegisterPage(),
    );
  }
}
