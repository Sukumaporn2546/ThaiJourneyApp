import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:thai_journey_app/main.dart" as app;
import "package:thai_journey_app/screens/attraction_detail_screen.dart";
import "package:thai_journey_app/screens/favourite_screen.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test full app', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(); // รอให้แอปพลิเคชันเรนเดอร์เสร็จสิ้น

    // ค้นหาและคลิกปุ่มที่ต้องการ
    final favbutton1 = find.byType(InkWell).at(0);
    final favbutton2 = find.byType(InkWell).at(1);

    await tester.tap(favbutton1);
    await tester.pumpAndSettle(); // รอการกระทำที่เกี่ยวข้องกับ UI
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(favbutton2);
    await tester.pumpAndSettle();

    // ตรวจสอบว่ามีไอคอน favorite ปรากฏอยู่
    expect(find.byIcon(Icons.favorite), findsAny);

    // ไปที่หน้าโปรด (favourite screen)
    await tester.tap(find.byKey(Key('Fav')));
    await tester.pumpAndSettle();
    expect(find.byType(FavouriteScreen), findsOne);

    // ตรวจสอบและคลิกที่รายการ attraction
    await tester.tap(find.byType(Card).at(0));
    await tester.pumpAndSettle();
    expect(find.byType(AttractionDetailScreen), findsOne);
    expect(find.text("รายละเอียด"), findsOne);

    // กดปุ่ม favourite ในหน้ารายละเอียด
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.byKey(Key('FavAttractionButton')));
    await tester.pumpAndSettle();

    // กลับไปหน้าก่อนหน้า
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.byKey(Key('AttractionBack')));
    await tester.pumpAndSettle();
    expect(find.byType(FavouriteScreen), findsOne);

    // กลับไปหน้าโฮม
    await Future.delayed(Duration(seconds: 2));
    await tester.tap(find.byKey(Key('Home')));
    await tester.pumpAndSettle();
    // await Future.delayed(Duration(seconds: 5));
  });
}
