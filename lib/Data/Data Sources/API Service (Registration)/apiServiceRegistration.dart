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

    late String Imagepath = "";
    late String venueName = "";
    late String courseCategory = "";
    late String courseType = "";
    late String examFee = "";
    late int examFeeID = 0;
    late String book = "";
    late String bookprice = "";
    late String venueID = "";
    late String courseCategoryID = "";
    late String courseTypeID = "";
    late String bookID = "";
    late String fullName = "";
    late String email = "";
    late String mobileNumber = "";
    late String dateOfBirth = "";
    late String gender = "";
    late String Linkedin = "";
    late String address = "";
    late String postCode = "";
    late String occupation = "";
    late String educationQualification = "";
    late String disciplineName = "";
    late String subject = "";
    late String passingYear = "";
    late String institute = "";
    late String result = "";
    late String passingID = "";

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      Imagepath = prefs.getString('image_path') ?? '';
      venueID = prefs.getString('Venue') ?? '';
      venueName = prefs.getString('Venue_Name') ?? '';
      courseCategoryID = prefs.getString('Exam Catagories') ?? '';
      courseCategory = prefs.getString('Exam Catagories_Name') ?? '';
      courseTypeID = prefs.getString('Exam Type') ?? '';
      courseType = prefs.getString('Exam Type_Name') ?? '';
      examFee = prefs.getString('Exam Fee') ?? '';
      examFeeID = prefs.getInt('Exam Fee ID') ?? 0;
      bookID = prefs.getString('Book') ?? '';
      book = prefs.getString('Book_Name') ?? '';
      bookprice = prefs.getString('BookPrice') ?? '';
      fullName = prefs.getString('full_name') ?? '';
      email = prefs.getString('email') ?? '';
      mobileNumber = prefs.getString('phone') ?? '';
      dateOfBirth = prefs.getString('date_of_birth') ?? '';
      gender = prefs.getString('gender') ?? '';
      Linkedin = prefs.getString('linkedin') ?? '';
      address = prefs.getString('address') ?? '';
      postCode = prefs.getString('post_code') ?? '';
      occupation = prefs.getString('occupation') ?? '';
      educationQualification = prefs.getString('qualification') ?? '';
      disciplineName = prefs.getString('subject_name') ?? '';
      subject = prefs.getString('subject_name') ?? '';
      passingYear = prefs.getString('passing_year') ?? '';
      institute = prefs.getString('institute') ?? '';
      result = prefs.getString('result') ?? '';
      passingID = prefs.getString('passing_id') ?? '';

      print('Image Path: $Imagepath');
      print('Venue Name: $venueName');
      print('Venue ID: $venueID');
      print('Course Category: $courseCategory');
      print('Course Catagory ID: $courseCategoryID');
      print('Course Type: $courseType');
      print('Course Type ID: $courseTypeID');
      print('Exam Fee: $examFee');
      print('Exam Fee: $examFeeID');
      print('Book: $book');
      print('Book ID: $bookID');
      print('Book Price: $bookprice');
      print('Full Name: $fullName');
      print('Email: $email');
      print('Mobile Number: $mobileNumber');
      print('Date of Birth: $dateOfBirth');
      print('Gender: $gender');
      print('Linkedin: $Linkedin');
      print('Address: $address');
      print('Post Code: $postCode');
      print('Occupation: $occupation');
      print('Education Qualification: $educationQualification');
      print('Discipline: $disciplineName');
      print('Subject: $subject');
      print('Passing Year: $passingYear');
      print('Institute: $institute');
      print('Result: $result');
      print('Passing ID: $passingID');


    request.fields['itee_venue_id'] = prefs.getString('Venue') ?? '';
    request.fields['itee_exam_category_id'] = prefs.getString('Exam Catagories') ?? '';
    request.fields['itee_exam_type_id'] = prefs.getString('Exam Type') ?? '';
    request.fields['exam_fees'] = prefs.getString('Exam Fee') ?? '';
    request.fields['fee_id'] = (prefs.getInt('Exam Fee ID') ?? 0).toString();
    request.fields['itee_book_id'] = prefs.getString('Book') ?? '';
    request.fields['itee_book_fees'] = prefs.getString('BookPrice') ?? '';
    request.fields['full_name'] = prefs.getString('full_name') ?? '';
    request.fields['email'] = prefs.getString('email') ?? '';
    request.fields['phone'] = prefs.getString('phone') ?? '';
    request.fields['dob'] = prefs.getString('date_of_birth') ?? '';
    request.fields['gender'] = prefs.getString('gender') ?? '';
    request.fields['address'] = prefs.getString('address') ?? '';
    request.fields['post_code'] = prefs.getString('post_code') ?? '';
    request.fields['occupation'] = prefs.getString('occupation') ?? '';
    request.fields['linkedin'] = prefs.getString('linkedin') ?? '';
    request.fields['education_qualification'] = prefs.getString('qualification') ?? '';

    final String? discipline = prefs.getString('discipline');
    final String? subjectName = prefs.getString('subject_name');

    if (discipline != null && discipline.isNotEmpty) {
      request.fields['discipline'] = discipline;
    }

    if (subjectName != null && subjectName.isNotEmpty) {
      request.fields['subject_name'] = subjectName;
    }

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
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        print('Missing Data :$jsonResponse');
        print('Failed to send registration data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending registration data: $e');
      return null;
    }
  }
}