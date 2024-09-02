import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/registermodels.dart';

/// A service class for managing user registration functionalities.
///
/// This class provides a method to register a new user with
/// the provided details and optional profile image.
///
/// ### Key Actions:
/// - **register(RegisterRequestmodel registerRequestModel, File? imageFile)**:
///   Registers a new user by sending their details and profile image.
///
///   - **Parameters**:
///     - [registerRequestModel]: An instance of
///       the `RegisterRequestmodel` containing user registration data.
///     - [imageFile]: An optional file containing the user's profile image.
///   - **Returns**:
///     A [String] message indicating the result of the registration process.
///
///   - **Throws**:
///     An exception if an error occurs during the request, providing
///     relevant error messages.
///
/// ### Notes:
/// - The method uses the `http` package to send a multipart POST request
///   to the registration API endpoint.
/// - The API response is logged for both successful and failed registrations.
/// - In case of errors, the method checks for specific validation errors
///   related to the email and phone fields and returns appropriate messages.
class APIService {
  Future<String> register(
      RegisterRequestmodel registerRequestModel, File? imageFile) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/registration";

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['app_name'] = 'itee';
      request.fields['full_name'] = registerRequestModel.fullName;
      request.fields['email'] = registerRequestModel.email;
      request.fields['phone'] = registerRequestModel.phone;
      request.fields['occupation'] = registerRequestModel.occupation;
      request.fields['linkedin'] = registerRequestModel.linkedin;
      request.fields['password'] = registerRequestModel.password;
      request.fields['password_confirmation'] = registerRequestModel.confirmPassword;

      var imageStream = http.ByteStream(imageFile!.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('photo', imageStream, length,
          filename: imageFile.path.split('/').last);

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        print(responseBody);
        print('User registered successfully!');
        return jsonResponse['message'];
      } else {
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
        var jsonResponse = jsonDecode(responseBody);
        print('Failed to register user: $jsonResponse');

        if (jsonResponse.containsKey('errors')) {
          var errors = jsonResponse['errors'];
          print(errors);
          var emailError = errors.containsKey('email') ? errors['email'][0] : '';
          var phoneError = errors.containsKey('phone') ? errors['phone'][0] : '';

          var errorMessage = '';
          if (emailError.isNotEmpty) errorMessage = emailError;
          if (phoneError.isNotEmpty) errorMessage = phoneError;

          print(errorMessage);
          return errorMessage;}
        else {
          print('Failed to register user: $responseBody');
          return 'Failed to register user. Please try again.';
        }
      }
    } catch (e) {
      print('Error occurred while registering user: $e');
      return 'Failed to register user. Please try again.';
    }
  }
}
