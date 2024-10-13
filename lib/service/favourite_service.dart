import 'package:http/http.dart' as http;
import 'dart:convert';

class FavouriteAttractionDetailApiService {
  static const String _apiKey =
      'GmMOh4APVrv7DqIFggy7F7GZxEjdLfDwePs7zNht1ifInSsg5L97yG0M3i(aT4TkgynD5hwJ501h2TN9OEkd1mG=====2';

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept-Language": "th",
    'Authorization': 'Bearer ${_apiKey}',
  };

  Future<Map<String, dynamic>?> fetchFavouriteAttractionDetailService(
      String place_id) async {
    final String _baseUrl =
        'https://tatapi.tourismthailand.org/tatapi/v5/attraction/${place_id}';

    final response = await http.get(Uri.parse(_baseUrl), headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
