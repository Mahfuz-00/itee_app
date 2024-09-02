import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for managing syllabus-related API interactions.
///
/// This class provides a method to fetch syllabus items from the API,
/// utilizing an authentication token stored in shared preferences.
///
/// ### Key Actions:
/// - **fetchSyllabusItems()**:
///   Fetches syllabus items by sending a GET request to the syllabus API endpoint.
///
///   - **Returns**:
///     A [Map<String, dynamic>] containing the syllabus items if the request
///     is successful.
///
///   - **Throws**:
///     An exception if the authentication token is empty or if the request
///     fails, providing relevant error messages.
class SyllabusAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  SyllabusAPIService._();

  static Future<SyllabusAPIService> create() async {
    var apiService = SyllabusAPIService._();
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

  Future<Map<String, dynamic>> fetchSyllabusItems() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/syllabus'),
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
        throw Exception('Failed to load syllabus');
      }
    } catch (e) {
      throw Exception('Error fetching syllabus: $e');
    }
  }
}
