import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../Pages/Exam Details UI/examDetailsUI.dart';
import '../../Pages/Login UI/loginUI.dart';
import '../../Pages/Registation UI/registrationvenuefromexamcard.dart';
import 'examcard.dart';
import 'listTileDashboardExam.dart';

class ExamRegistrationCarousel extends StatefulWidget {
  final List<Widget> examFeeWidgets;
  final bool auth;

  const ExamRegistrationCarousel({
    Key? key,
    required this.examFeeWidgets,
    required this.auth,
  }) : super(key: key);

  @override
  _ExamRegistrationCarouselState createState() => _ExamRegistrationCarouselState();
}

class _ExamRegistrationCarouselState extends State<ExamRegistrationCarousel> {
  int _currentExamRegistrationPage = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 420,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: widget.examFeeWidgets.isEmpty
          ? Center(
        child: Text(
          'No Exam Available right now',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black54,
            fontFamily: 'default',
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : Stack(
        children: [
          PageView.builder(
            controller: PageController(viewportFraction: 1),
            itemCount: widget.examFeeWidgets.length,
            onPageChanged: (index) {
              setState(() {
                _currentExamRegistrationPage = index;
              });
            },
            itemBuilder: (context, index) {
              ExamTemplate exam = widget.examFeeWidgets[index] as ExamTemplate;
              return ExamCard(
                examImage: 'https://www.bcc.touchandsolve.com' + exam.image,
                examName: exam.name,
                examCatagories: exam.Catagories,
                examFee: exam.price,
                onDetailsPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamDetailsUI(details: exam.Details),
                    ),
                  );
                },
                onSharePressed: () async {
                  Share.share(
                    exam.Details,
                    subject: 'Exam Details',
                  );
                },
                onRegistrationPressed: () {
                  if (widget.auth) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationCenterUIFromExamCard(
                          Catagory: exam.Catagories,
                          Type: exam.name,
                          Fee: exam.price,
                          CatagoryId: exam.CatagoryID,
                          TypeId: exam.typeID,
                          FeeId: exam.priceID,
                        ),
                      ),
                    );
                  } else {
                    const snackBar = SnackBar(
                      content: Text('Please Login First!!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginUI()),
                    );
                  }
                },
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios,
              color: _currentExamRegistrationPage == 0 ? Colors.transparent : Colors.black,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios,
              color: _currentExamRegistrationPage == widget.examFeeWidgets.length - 1
                  ? Colors.transparent
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
