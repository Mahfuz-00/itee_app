import 'package:flutter/material.dart';
import 'BookWidget.dart';

class BookSection extends StatelessWidget {
  final List<Widget> bookWidgets;
  final double screenWidth;

  const BookSection({
    Key? key,
    required this.bookWidgets,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Candidate can also purchase books from the following offices on cash payment',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(143, 150, 158, 1),
            fontFamily: 'default',
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.9,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 162, 222, 1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Book',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
                BookCarousel(bookWidgets: bookWidgets),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
