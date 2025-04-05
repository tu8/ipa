import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() async {
  // تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  final directory = Directory('assets/icon');
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final iconWidget = Container(
    width: 1024,
    height: 1024,
    color: Colors.black,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sports_esports, size: 500, color: Colors.green),
          const SizedBox(height: 20),
          Text(
            "لعبة الثعبان",
            style: TextStyle(
              color: Colors.white,
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );

  print('تم إنشاء أيقونة افتراضية في مجلد assets/icon');
  print(
    'يجب عليك توفير أيقونة خاصة بك باسم icon.png في المسار: assets/icon/icon.png',
  );
}
