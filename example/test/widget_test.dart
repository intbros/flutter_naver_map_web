// This is a basic Flutter widget test for Naver Map Web example.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_naver_map_web_example/main.dart';

void main() {
  testWidgets('Naver Map Web app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Verify that our app has the correct title
    expect(find.text('Flutter Naver Map Web Example'), findsOneWidget);
    
    // Verify that the Places section exists
    expect(find.text('Places'), findsOneWidget);
    
    // Verify that at least one place is displayed
    expect(find.text('Seoul City Hall'), findsOneWidget);
    expect(find.text('Gyeongbokgung Palace'), findsOneWidget);
    
    // Verify that the floating action button exists
    expect(find.byIcon(Icons.fit_screen), findsOneWidget);
  });
}
