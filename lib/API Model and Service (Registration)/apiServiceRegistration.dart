import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamRegistrationAPIService {
  static const String apiUrl = 'https://bcc.touchandsolve.com/api/itee/exam/registration';

  late final String authToken;

  ExamRegistrationAPIService._();

  static Future<ExamRegistrationAPIService> create() async {
    var apiService = ExamRegistrationAPIService._();
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

  Future<Map<String, dynamic>?> sendRegistrationDataFromSharedPreferences(File? imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    });

    request.fields['itee_venue_id'] = prefs.getString('Venue') ?? '';
    request.fields['itee_exam_category_id'] = prefs.getString('Exam Catagories') ?? '';
    request.fields['itee_exam_type_id'] = prefs.getString('Exam Type') ?? '';
    request.fields['exam_fees'] = prefs.getString('Exam fee') ?? '';
    request.fields['itee_book_id'] = prefs.getString('Book') ?? '';
    request.fields['full_name'] = prefs.getString('full_name') ?? '';
    request.fields['email'] = prefs.getString('email') ?? '';
    request.fields['phone'] = prefs.getString('phone') ?? '';
    request.fields['dob'] = prefs.getString('date_of_birth') ?? '';
    request.fields['gender'] = prefs.getString('gender') ?? '';
    request.fields['address'] = prefs.getString('address') ?? '';
    request.fields['post_code'] = prefs.getString('post_code') ?? '';
    request.fields['occupation'] = prefs.getString('occupation') ?? '';
    request.fields['education_qualification'] = prefs.getString('date_of_birth') ?? '';
    request.fields['subject_name'] = prefs.getString('subject_name') ?? '';
    request.fields['passing_year'] = prefs.getString('passing_year') ?? '';
    request.fields['institute_name'] = prefs.getString('institute') ?? '';
    request.fields['result'] = prefs.getString('result') ?? '';
    request.fields['previous_passing_id'] = prefs.getString('passing_id') ?? '';

    if (imageFile != null) {
      var imageStream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile('photo', imageStream, length, filename: imageFile.path.split('/').last);
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        print('Registration data sent successfully');
        print(jsonResponse);
        return jsonResponse;
      } else {
        print('Failed to send registration data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending registration data: $e');
      return null;
    }
  }
}