import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for interacting with the **Exam Material API**.
///
/// This class provides methods to **load authentication tokens** from shared preferences
/// and to **fetch exam material items** such as course outlines.
///
/// ### Key Variables:
/// - `baseUrl`: The base URL for the API endpoint.
/// - `authToken`: The authentication token loaded from shared preferences.
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service and load the authentication token.
/// - **_loadAuthToken()**: A private method that retrieves the token from shared preferences.
/// - **fetchExamMaterialItems()**: Fetches the exam material items from the API endpoint.
class ExamMaterialAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  ExamMaterialAPIService._();

  static Future<ExamMaterialAPIService> create() async {
    var apiService = ExamMaterialAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<Map<String, dynamic>> fetchExamMaterialItems() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/course/outline'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load course outline');
      }
    } catch (e) {
      throw Exception('Error fetching course outline: $e');
    }
  }
}
