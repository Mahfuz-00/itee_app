import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentViewAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  PaymentViewAPIService._();

  static Future<PaymentViewAPIService> create() async {
    var apiService = PaymentViewAPIService._();
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

  Future<Map<String, dynamic>?> getallPayment() async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/itee/my-unpaid-list'),
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
