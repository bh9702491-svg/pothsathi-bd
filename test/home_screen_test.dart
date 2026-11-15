import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pothsathi_bd/core/theme.dart';
import 'package:pothsathi_bd/features/home/home_screen.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const HomeScreen()),
    );
  }

  testWidgets('হোম স্ক্রিনে নাম, ট্যাগলাইন ও ৬টি ফিচার দেখায়', (tester) async {
    await pumpHome(tester);

    expect(find.text('পথসাথী BD'), findsOneWidget);
    expect(find.text('সহায়তা খুঁজুন • দক্ষতা গড়ুন • ভবিষ্যৎ সাজান'),
        findsOneWidget);
    for (final title in [
      'সরকারি সেবা',
      'ভাতা ও সুবিধা',
      'ক্যারিয়ার রোডম্যাপ',
      'কাছের অফিস',
      'আমার চেকলিস্ট',
      'সংরক্ষিত গাইড',
    ]) {
      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('ফিচারে ট্যাপ করলে "তৈরি হচ্ছে" পাতা খোলে', (tester) async {
    await pumpHome(tester);

    await tester.ensureVisible(find.text('কাছের অফিস'));
    await tester.tap(find.text('কাছের অফিস'));
    await tester.pumpAndSettle();

    expect(find.text('এই ফিচারটি এখনও তৈরি হচ্ছে'), findsOneWidget);
  });
}
