import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for interacting with the **Dashboard API**.
///
/// This class provides methods to **load authentication tokens** from shared preferences
/// and to **fetch dashboard items**.
///
/// ### Key Variables:
/// - `baseUrl`: The base URL for the API endpoint.
/// - `authToken`: The authentication token loaded from shared preferences.
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service and load the authentication token.
/// - **_loadAuthToken()**: A private method that retrieves the token from shared preferences.
/// - **fetchDashboardItems()**: Fetches the dashboard items from the API endpoint, with
///   different headers depending on the presence of the authentication token. If the token
///   is empty, a request is made without authorization. It handles different response
///   status codes, including a fallback for 500 status code.
class DashboardAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  DashboardAPIService._();

  static Future<DashboardAPIService> create() async {
    var apiService = DashboardAPIService._();
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

  Future<Map<String, dynamic>> fetchDashboardItems() async {
    final String token = await authToken;
    final response;
    try {
      if (token.isEmpty) {
        response = await http.get(
            Uri.parse('$baseUrl/itee/dashboard'),
            headers: {
              'Accept': 'application/json',
            },
        );
      }else {
        response = await http.get(
          Uri.parse('$baseUrl/itee/dashboard'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );
      }


      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else if (response.statusCode == 500) {
        return {};
      } else {
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard items: $e');
    }
  }
}
