import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for interacting with the **Type API**.
///
/// This class provides methods to **load authentication tokens** from shared preferences
/// and to **fetch types** for specific exam categories.
///
/// ### Key Variables:
/// - `baseUrl`: The base URL for the API endpoint.
/// - `authToken`: The authentication token loaded from shared preferences.
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service and load the authentication token.
/// - **_loadAuthToken()**: A private method that retrieves the token from shared preferences.
/// - **fetchTypes()**: Fetches the types for a given **examCategoryId** from the API.
class TypeAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  TypeAPIService._();

  static Future<TypeAPIService> create() async {
    var apiService = TypeAPIService._();
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

  Future<Map<String, dynamic>> fetchTypes(String examCategoryId) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      print(examCategoryId);
      final response = await http.get(
        Uri.parse('$baseUrl/itee/category/types/$examCategoryId'),
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
        throw Exception('Failed to load type');
      }
    } catch (e) {
      throw Exception('Error fetching type: $e');
    }
  }
}
