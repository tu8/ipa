# حزمة لعبة الثعبان لنظام iOS

هذه الحزمة تحتوي على جميع الملفات اللازمة لبناء تطبيق لعبة الثعبان لنظام iOS.

## محتويات الحزمة

- `lib/`: الشيفرة المصدرية للعبة
- `ios/`: ملفات تكوين iOS
- `assets/`: الموارد مثل الأيقونات والصور

## كيفية بناء ملف IPA

### باستخدام جهاز Mac

1. افتح Terminal
2. انتقل إلى مجلد الحزمة
3. قم بتثبيت Flutter إذا لم يكن مثبتاً
4. نفذ الأوامر التالية:

```bash
# تثبيت التبعيات
flutter pub get

# بناء التطبيق
flutter build ios --release

# فتح المشروع في Xcode
open ios/Runner.xcworkspace
```

5. في Xcode:
   - اختر Device > Any iOS Device
   - من القائمة، اختر Product > Archive
   - بعد الأرشفة، اختر "Distribute App" ثم اختر "Ad Hoc" أو "Development"
   - اتبع التعليمات واختر حفظ ملف IPA

### باستخدام خدمة Codemagic (بدون Mac)

1. قم بتحميل الحزمة إلى GitHub
2. سجل في [Codemagic](https://codemagic.io/)
3. أضف المشروع من GitHub
4. قم بإعداد سير العمل كما هو موضح في ملف `CODEMAGIC_IPA_GUIDE.md`
5. اضغط على "Start build"
6. قم بتنزيل ملف IPA من المخرجات

## الخطوات التفصيلية

لمزيد من التفاصيل، يمكنك الاطلاع على الأدلة التالية:

- `IOS_DEPLOYMENT_GUIDE.md`: دليل مفصل باستخدام Mac
- `CODEMAGIC_IPA_GUIDE.md`: دليل مفصل باستخدام Codemagic
- `ALTSTORE_GUIDE.md`: دليل تثبيت IPA باستخدام AltStore 