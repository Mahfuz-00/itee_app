import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for managing **Result View** functionalities,
/// specifically for retrieving a list of results for the user.
///
/// This class provides methods to manage authentication and fetch
/// the results from the API.
///
/// ### Key Actions:
/// - **getallResult()**:
///   Fetches all results associated with the authenticated user.
///
///   - **Returns**:
///     A [Map<String, dynamic>?] containing the results data,
///     or null if the request fails.
///
///   - **Throws**:
///     An exception if the [authToken] is empty or if an error occurs
///     during the request, providing relevant error messages.
class ResultViewAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  ResultViewAPIService._();

  static Future<ResultViewAPIService> create() async {
    var apiService = ResultViewAPIService._();
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

  Future<Map<String, dynamic>?> getallResult() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/my-results-list'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print(response.request);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load result');
      }
    } catch (e) {
      throw Exception('Error fetching result: $e');
    }
  }
}
