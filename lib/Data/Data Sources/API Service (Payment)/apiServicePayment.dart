import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for handling **Payment Management** functionalities,
/// specifically for sending exam registration payment data to the API.
///
/// This class provides methods to manage authentication and send
/// transaction and registration IDs to the server.
///
/// ### Key Actions:
/// - **sendIdsFromSharedPreferences(String transactionId, int examRegistrationId)**:
///   Sends a POST request with the transaction and exam registration IDs to
///   the specified API endpoint.
///
///   - **Parameters**:
///     - `transactionId`: The ID of the transaction to be sent.
///     - `examRegistrationId`: The ID of the exam registration to be sent.
///
///   - **Returns**: A `bool` indicating whether the IDs were sent
///     successfully (`true`) or not (`false`).
///
///   - **Throws**: An exception if an error occurs during the request,
///     providing relevant error messages.
class PaymentAPIService {
  static const String apiUrl = 'https://bcc.touchandsolve.com/api/itee/payment/exam/registration';

  late final String authToken;

  PaymentAPIService._();

  static Future<PaymentAPIService> create() async {
    var apiService = PaymentAPIService._();
    await apiService._loadAuthToken();
    print('API service created');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Token loaded: $authToken');
  }

  Future<bool> sendIdsFromSharedPreferences(String transactionId, int examRegistrationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'transaction_id': transactionId,
          'exam_registration_id': examRegistrationId,
        }),
      );

      if (response.statusCode == 200) {
        print('IDs sent successfully');
        return true;
      } else {
        print('Failed to send payments. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending payments: $e');
      return false;
    }
  }
}
