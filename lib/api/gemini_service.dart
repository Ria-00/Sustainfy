import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  // final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  final String apiKey = "AIzaSyDavRc6oLdOoh4Wzjn__qz7if0n0o6mhSU";

  Future<Map<String, dynamic>> categorizeEvent(
      String title, String description) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');
    //curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$YOUR_API_KEY"
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Classify the following event under one or more of the relavent 17 Sustainable Development Goals (SDGs) based on its title and description. Return the SDG goal name(s) and number(s) in a key value form, key is the sdg number and value is the name.\n\n"
                        "Title: $title\n"
                        "Description: $description"
              }
            ]
          }
        ]
      }),
    );
    print(response.body.toString());

    if (response.statusCode == 200) {
      // Parse the JSON
      Map<String, dynamic> parsedJson = jsonDecode(response.body.toString());

      // Extract text
      String text = parsedJson["candidates"][0]["content"]["parts"][0]["text"];

      // Remove code block formatting
      text = text.replaceAll("```json", "").replaceAll("```", "").trim();

      print(text);
      return jsonDecode(text);
    } else {
      throw Exception("Failed to fetch classification: ${response.body}");
    }
  }

  Future<int> getPoints(String title, String description, int numOfSDGs,
      DateTime startTime, DateTime endTime) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": "Evaluate the following event based on the given scoring criteria and assign a total score out of 800. Follow the exact scoring breakdown:\n\n"
                    "1. **Global/Local Impact (0–200 points):**\n"
                    "- If the event has a local impact, assign **100 points**.\n"
                    "- If it has a global impact, assign **200 points**.\n\n"
                    "2. **SDG Alignment (0–200 points):**\n"
                    "- If the event aligns with **1 SDG**, assign **50 points**.\n"
                    "- If it aligns with **2 SDGs**, assign **100 points**.\n"
                    "- If it aligns with **3 or more SDGs**, assign **200 points**.\n\n"
                    "3. **Volunteer Hours (0–150 points):**\n"
                    "- If the event lasts **1 hour**, assign **50 points**.\n"
                    "- If it lasts **2–4 hours**, assign **100 points**.\n"
                    "- If it lasts **5+ hours**, assign **150 points**.\n\n"
                    "4. **Active Involvement (0–150 points):**\n"
                    "- If participants are **passive attendees**, assign **50 points**.\n"
                    "- If they are **actively involved**, assign **100 points**.\n"
                    "- If they take a **leadership role**, assign **150 points**.\n\n"
                    "5. **Long-term Actions (0–100 points):**\n"
                    "- If the event leads to a **small change**, assign **50 points**.\n"
                    "- If it results in a **major long-term impact**, assign **100 points**.\n\n"
                    "### Event Details:\n"
                    "Title: $title\n"
                    "Description: $description\n"
                    "Number of SDGs: $numOfSDGs\n"
                    "Start Time: $startTime\n"
                    "End Time: $endTime\n\n"
                    "### Response Format:\n"
                    "Return only the total score as an **integer** (e.g., 450). Do not include any explanation or extra text."
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedJson = jsonDecode(response.body);
      String text = parsedJson["candidates"][0]["content"]["parts"][0]["text"];
      print(text);
      return int.parse(text.trim()); // Ensure it's converted to an integer
    } else {
      throw Exception("Failed to fetch points: ${response.body}");
    }
  }
}
