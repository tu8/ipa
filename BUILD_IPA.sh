#!/bin/bash

# سكريبت بناء ملف IPA للعبة الثعبان
# قم بتشغيل هذا الملف من Terminal على Mac

# تثبيت التبعيات
flutter pub get

# بناء التطبيق للإصدار
flutter build ios --release

# الانتقال إلى مجلد iOS
cd ios

# التأكد من الإعدادات
echo "قبل المتابعة، يرجى تحديث ملف ExportOptions.plist بمعرف الفريق الخاص بك"
echo "teamID: يجب تحديثه بمعرف فريق المطور الخاص بك"
echo "provisioningProfiles: يجب تحديث معرف الحزمة وملف التوقيع"
echo ""
read -p "هل قمت بتحديث ExportOptions.plist؟ (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "يرجى تحديث ExportOptions.plist أولاً"
    exit 1
fi

# بناء الأرشيف
echo "جاري بناء الأرشيف..."
xcodebuild -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath build/Runner.xcarchive

# تصدير ملف IPA
echo "جاري تصدير ملف IPA..."
xcodebuild -exportArchive -archivePath build/Runner.xcarchive -exportOptionsPlist ../ExportOptions.plist -exportPath build/Runner.ipa

# التحقق من الاكتمال
if [ -d "build/Runner.ipa" ]; then
    echo "تم إنشاء ملف IPA بنجاح!"
    echo "مسار الملف: build/Runner.ipa/Runner.ipa"
else
    echo "حدث خطأ أثناء إنشاء ملف IPA"
fi 