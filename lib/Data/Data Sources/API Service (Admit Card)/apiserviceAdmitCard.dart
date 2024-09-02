import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for interacting with the **Admit Card API**.
///
/// This class provides methods to **load authentication tokens** from shared preferences
/// and to **fetch admit card items** for a specific examinee using their **Examinee ID**.
///
/// ### Key Variables:
/// - `baseUrl`: The base URL for the API endpoint.
/// - `authToken`: The authentication token loaded from shared preferences.
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service and load the authentication token.
/// - **_loadAuthToken()**: A private method that retrieves the token from shared preferences.
/// - **fetchAdmitCardItems()**: Fetches admit card data for a given [ExamineeID] from the API.
class AdmitCardAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  AdmitCardAPIService._();

  static Future<AdmitCardAPIService> create() async {
    var apiService = AdmitCardAPIService._();
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

  Future<Map<String, dynamic>> fetchAdmitCardItems(String ExamineeID) async {

    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/admit/$ExamineeID'),
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
        throw Exception('Failed to load Admit Card');
      }
    } catch (e) {
      throw Exception('Error fetching admit card: $e');
    }
  }
}
