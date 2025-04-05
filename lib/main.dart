import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'snake_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ضبط نمط شريط الحالة لجعله متوافقًا مع التصميم
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لعبة الثعبان',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home:
          Platform.isIOS
              ? CupertinoApp(
                debugShowCheckedModeBanner: false,
                theme: const CupertinoThemeData(
                  brightness: Brightness.dark,
                  primaryColor: CupertinoColors.systemGreen,
                ),
                home: const CupertinoPageScaffold(
                  backgroundColor: Colors.black,
                  child: SafeArea(child: SnakeGame()),
                ),
              )
              : const SnakeGamePage(),
    );
  }
}

class SnakeGamePage extends StatelessWidget {
  const SnakeGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const SafeArea(child: SnakeGame()),
    );
  }
}
