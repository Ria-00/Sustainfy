import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  static const String _baseUrl = 'https://api.unsplash.com';
  static const String _accessKey =
      'L9ERMk14TpJIUdjZ2XT3GasoviIdOc9JAFKb31Cbo64'; // Replace this with your real key

  static Future<String?> fetchImageUrl(String query) async {
    final url = Uri.parse(
      '$_baseUrl/search/photos?page=1&per_page=1&query=$query&client_id=$_accessKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        print(data['results'][0]['urls']['regular']);
        return data['results'][0]['urls']['regular'];
      } else {
        return null; // No images found for query
      }
    } else {
      throw Exception('Failed to load image from Unsplash');
    }
  }
}
