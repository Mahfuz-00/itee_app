import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget {
  final String examImage;
  final String examName;
  final String examCatagories;
  final String examFee;
  final VoidCallback onDetailsPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onRegistrationPressed;

  ExamCard({
    required this.examImage,
    required this.examName,
    required this.examCatagories,
    required this.examFee,
    required this.onDetailsPressed,
    required this.onSharePressed,
    required this.onRegistrationPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: screenHeight * 0.25,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog when tapped
                                },
                                child: CachedNetworkImage(
                                  imageUrl: examImage,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: examImage,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) => Center(
                            child: Icon(Icons
                                .error), // Error icon for image load failure
                          ),
                        ),
                      ),
                    )),
                Divider(),
                Text(
                  'Exam Type: $examName',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Exam Catagories: $examCatagories',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Exam Fee: $examFee',
                  /*৳*/
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onDetailsPressed,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 162, 222, 1),
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.info, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onSharePressed,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 162, 222, 1),
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.share, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onRegistrationPressed,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 162, 222, 1),
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Icon(Icons.app_registration, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
