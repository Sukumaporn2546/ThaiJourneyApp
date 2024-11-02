import 'package:flutter_test/flutter_test.dart';
import 'package:thai_journey_app/Provider/favourite_provider.dart';

void main() {
  test('Toggle favourite status', () {
    final provider = FavouriteProvider();

    // Check initial state
    expect(provider.isExist('place_id_1'), false);

    // Toggle favourite
    provider.toggleFavourite('place_id_1');
    expect(provider.isExist('place_id_1'), true);

    // Toggle back
    provider.toggleFavourite('place_id_1');
    expect(provider.isExist('place_id_1'), false);
  });
}
