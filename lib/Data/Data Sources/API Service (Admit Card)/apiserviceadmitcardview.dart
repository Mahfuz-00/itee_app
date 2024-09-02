import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for fetching all admit cards with the **Admit Card view API**.
///
/// This class provides methods to **load authentication tokens** from shared preferences
/// and to **fetch all admit cards** associated with the authenticated user.
///
/// ### Key Variables:
/// - `baseUrl`: The base URL for the API endpoint.
/// - `authToken`: The authentication token loaded from shared preferences.
///
/// ### Key Actions:
/// - **create()**: A factory method to instantiate the service and load the authentication token.
/// - **_loadAuthToken()**: A private method that retrieves the token from shared preferences.
/// - **getallAdmitCard()**: Fetches all admit card data for the authenticated user from the API.
class AdmitCardViewAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  AdmitCardViewAPIService._();

  static Future<AdmitCardViewAPIService> create() async {
    var apiService = AdmitCardViewAPIService._();
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

  Future<Map<String, dynamic>?> getallAdmitCard() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/my-admitcards-list'),
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
        throw Exception('Failed to load admit card');
      }
    } catch (e) {
      throw Exception('Error fetching admit card: $e');
    }
  }
}
