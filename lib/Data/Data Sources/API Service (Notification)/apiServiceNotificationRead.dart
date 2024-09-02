import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for handling **Notification Management** functionalities,
/// specifically for marking notifications as read.
///
/// This class provides a method to read notifications by making a GET request
/// to the designated API endpoint with the user's authentication token.
///
/// ### Key Actions:
/// - **readNotification()**: Sends a GET request to the notifications
///   endpoint to mark notifications as read.
///
///   - **Returns**: A `bool` indicating whether the notification was read
///     successfully (`true`) or not (`false`).
///
///   - **Throws**: An exception if the authentication token is empty
///     or if an error occurs during the request, providing relevant
///     error messages.
class NotificationReadApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  NotificationReadApiService._();

  static Future<NotificationReadApiService> create() async {
    var apiService = NotificationReadApiService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(authToken);
  }


  Future<bool> readNotification() async {
    print(authToken);
    try {
      if (authToken.isEmpty) {
        print(authToken);
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/notification/read'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Notification Read!!');
        return true;
      } else {
        print(response.body);
        print('Failed to read Notification: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      final response = await http.post(
        Uri.parse('$URL/sign/out'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );
      print(response.body);
      print('Exception While Reading Notification: $e');
      return false;
    }
  }
}
