import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<void> main() async {
  // تأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // إنشاء أيقونة وحفظها
  await createIcon(512, 512, 'assets/icon/icon.png');
  print('تم إنشاء الأيقونة بنجاح!');
  exit(0);
}

Future<void> createIcon(int width, int height, String path) async {
  // إنشاء صورة فارغة بلون أسود
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = Size(width.toDouble(), height.toDouble());
  final paint = Paint();

  // خلفية سوداء
  paint.color = Colors.black;
  canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

  // رسم الثعبان (أجزاء خضراء)
  paint.color = Colors.green;

  // الرأس (أكبر حجمًا)
  paint.color = Colors.lightGreen;
  canvas.drawRect(
    Rect.fromLTWH(
      size.width * 0.5,
      size.height * 0.3,
      size.width * 0.15,
      size.height * 0.15,
    ),
    paint,
  );

  // جسم الثعبان (أجزاء متعددة)
  paint.color = Colors.green;
  canvas.drawRect(
    Rect.fromLTWH(
      size.width * 0.35,
      size.height * 0.3,
      size.width * 0.15,
      size.height * 0.15,
    ),
    paint,
  );
  canvas.drawRect(
    Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.3,
      size.width * 0.15,
      size.height * 0.15,
    ),
    paint,
  );
  canvas.drawRect(
    Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.45,
      size.width * 0.15,
      size.height * 0.15,
    ),
    paint,
  );
  canvas.drawRect(
    Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.6,
      size.width * 0.15,
      size.height * 0.15,
    ),
    paint,
  );
  canvas.drawRect(
    Rect.fromLTWH(
      size.width * 0.35,
      size.height * 0.6,
      size.width * 0.15,
      size.height * 0.15,
    ),
    paint,
  );
  canvas.drawRect(
    Rect.fromLTWH(
      size.width * 0.5,
      size.height * 0.6,
      size.width * 0.15,
      size.height * 0.15,
    ),
    paint,
  );

  // رسم الطعام (دائرة حمراء)
  paint.color = Colors.red;
  canvas.drawCircle(
    Offset(size.width * 0.7, size.height * 0.4),
    size.width * 0.08,
    paint,
  );

  // تحويل الرسم إلى صورة
  final picture = recorder.endRecording();
  final img = await picture.toImage(width, height);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  // حفظ الصورة كملف
  final directory = Directory(path.substring(0, path.lastIndexOf('/')));
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final file = File(path);
  await file.writeAsBytes(buffer);
}
