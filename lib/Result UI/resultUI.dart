import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itee_exam_app/Template%20Models/resultDetailsTile.dart';
import 'package:itee_exam_app/Template%20Models/templateerrorcontainerAlert.dart';

import '../API Model and Service (Result)/apiserviceResult.dart';
import '../Template Models/templateerrorcontainer.dart';

class Result extends StatefulWidget {
  final bool shouldRefresh;

  const Result({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool _pageLoading = true;
  late TextEditingController _idcontroller = TextEditingController();
  bool buttonClicked = false;

  @override
  void initState() {
    super.initState();
    print('initState called');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
          title: Text(
            'Result',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Your Student ID',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 350,
                              height: 70,
                              child: TextFormField(
                                controller: _idcontroller,
                                style: const TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  labelText: 'Student ID',
                                  labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'default',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(0, 162, 222, 1),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.45,
                                        MediaQuery.of(context).size.height *
                                            0.06),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    int Id = int.parse(_idcontroller.text);
                                    fetchIndividualResultAndNavigate(Id);
                                    buttonClicked = true;
                                  },
                                  child: const Text('Search',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buttonClicked
                        ? Center(child: CircularProgressIndicator())
                        : alert == 1
                        ? buildNoRequestsWidgetAlert(MediaQuery.of(context).size.width, 'Student not found')
                        : alert == 2
                        ? buildNoRequestsWidgetAlert(MediaQuery.of(context).size.width, 'No result')
                        : _buildList(Results),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> Results = [];
  int alert = 0;

  Future<void> fetchIndividualResultAndNavigate(int id) async {
    setState(() {
      _isLoading = true;
      buttonClicked = true;
    });

    final apiService = await ResultAPIService.create();
    final result = await apiService.getResult(id);

    if (result != null) {
      print(result);
      final message = result['message'];
      if (message.isNotEmpty) {
        setState(() {
          _isLoading = false;
          buttonClicked = false;
          alert = 1;
        });
        buildNoRequestsWidget(MediaQuery.of(context).size.width, 'Student not found');
        return;
      }
      else{

        final records = result['records'];
        if (records is Map && records.containsKey('result')) {
          final resultList = records['result'];
          print(resultList);
          if (resultList is List && resultList.isNotEmpty) {
            final List<Widget> resultWidgets = resultList.map<Widget>((item) {
              return ResultInfoCard(
                Name: item['name'],
                ExamName: item['subject_name'],
                Result: item['result'].toString(),
              );
            }).toList();

            setState(() {
              Results = resultWidgets;
              _isLoading = false;
              buttonClicked = false;
              alert = 3;
            });
          } else {
            setState(() {
              _isLoading = false;
              buttonClicked = false;
              alert = 2;
            });
            buildNoRequestsWidgetAlert(MediaQuery.of(context).size.width, 'No result');
          }
        } else {
          setState(() {
            _isLoading = false;
            buttonClicked = false;
            alert = 2;
          });
          buildNoRequestsWidgetAlert(
              MediaQuery.of(context).size.width, 'No result');
        }
      }
    } else {
      setState(() {
        _isLoading = false;
        buttonClicked = false;
        alert = 1;
      });
      buildNoRequestsWidgetAlert(
          MediaQuery.of(context).size.width, 'Student not Found');
    }
  }

  Widget _buildList(List<Widget> items) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
        ),
      ],
    );
  }
}
