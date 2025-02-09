// api_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_client/models/analyse_request.dart';

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000';

  Future<List<PlantStat>> analyzePlants(AnalyzeRequest request) async {
    final response = await http
        .post(
          Uri.parse("$baseUrl/analyze-plants"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(request.toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      print("Raw response: ${response.body}");
      return jsonResponse.map((item) => PlantStat.fromJson(item)).toList();
    } else {
      throw Exception("Error analyzing plants: ${response.body}");
    }
  }

  /// POST: Get Weather Variation (Calendar)
  Future<dynamic> getDates(TestConnectionDto request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/calendar"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error testing connection: ${response.body}");
    }
  }
}
