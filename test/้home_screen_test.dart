import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thai_journey_app/screens/suma_home_screen.dart'; // นำเข้า HomeScreen1

void main() {
  testWidgets('HomeScreen1 displays correct title and subtitle',
      (WidgetTester tester) async {
    // Build the HomeScreen1 widget
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen1(),
      ),
    );

    // Check if the title "ค้นพบ" is displayed
    expect(find.text('ค้นพบ'), findsOneWidget);

    // Check if the subtitle "สำรวจสถานที่ท่องเที่ยวในประเทศไทย" is displayed
    expect(find.text('สำรวจสถานที่ท่องเที่ยวในประเทศไทย'), findsOneWidget);

    // Check if the search field is displayed
    expect(find.byType(TextField), findsOneWidget);
  });
}
