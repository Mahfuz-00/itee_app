import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for interacting with the **Fee API**.
///
/// This class provides methods to **load authentication tokens** from shared preferences
/// and to **fetch exam fees** for specific exam categories and types.
///
/// ### Key Variables:
/// - `baseUrl`: The base URL for the API endpoint.
/// - `authToken`: The authentication token loaded from shared preferences.
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service and load the authentication token.
/// - **_loadAuthToken()**: A private method that retrieves the token from shared preferences.
/// - **fetchExamFee()**: Fetches the exam fee for a given **examCategoryId** and **examTypeId** from the API.
class FeeAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  FeeAPIService._();

  static Future<FeeAPIService> create() async {
    var apiService = FeeAPIService._();
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

  Future<Map<String, dynamic>> fetchExamFee(String examCategoryId, String examTypeId) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      print(examCategoryId);
      print(examTypeId);
      final response = await http.get(
        Uri.parse('$baseUrl/itee/get/exam/fee/$examCategoryId/$examTypeId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load fee');
      }
    } catch (e) {
      throw Exception('Error fetching fee: $e');
    }
  }
}
