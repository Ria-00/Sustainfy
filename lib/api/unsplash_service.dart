import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UnsplashService {
  static const String _baseUrl = 'https://api.unsplash.com';
  static String _accessKey = dotenv.env['UNSPLASH_API'] ?? ''; 

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
