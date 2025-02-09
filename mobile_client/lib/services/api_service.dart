// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_client/models/analyse_request.dart';
import 'package:mobile_client/models/environment.dart';

class ApiService {
  final String baseUrl = Environment.serverBaseUrl;

  Future<List<PlantStat>> analyzePlants(AnalyzeRequest request) async {
    final response = await http
        .post(
          Uri.parse("$baseUrl/analyze-plants"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(request.toJson()),
        )
        .timeout(const Duration(seconds: 60));
    print("Response status: ${response.statusCode}");
    print("Response body length: ${response.body.length}");
    print("Response body: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => PlantStat.fromJson(item)).toList();
    } else {
      throw Exception("Error analyzing plants: ${response.body}");
    }
  }

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
