import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'screens/home_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/exercises_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBGtH8m0CJ17XJiqkE6T9yaLlg1soSIqWs",
      appId: "1:824190314228:android:305128bd61cc4a74a6a0a1",
      messagingSenderId: "824190314228",
      projectId: "djangify-eafdb",
    ),
  )
      : await Firebase.initializeApp();

  await FlutterDownloader.initialize(debug: true);
  runApp(DjangifyApp());
}

class DjangifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tekma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/lessons') {
          final args = settings.arguments as Map<String, dynamic>?;

          return MaterialPageRoute(
            builder: (context) {
              return LessonsScreen(
                selectedClass: args?['class'] ?? '',
                selectedCourse: args?['course'] ?? '',
              );
            },
          );
        } else if (settings.name == '/exercises') {
          final args = settings.arguments as Map<String, dynamic>?;

          return MaterialPageRoute(
            builder: (context) {
              return ExercisesScreen(
                selectedClass: args?['class'] ?? '',
                selectedCourse: args?['course'] ?? '',
              );
            },
          );
        }

        // Default route
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      },
    );
  }
}
