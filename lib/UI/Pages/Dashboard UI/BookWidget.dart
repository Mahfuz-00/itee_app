import 'package:flutter/material.dart';

import '../../Widgets/bookcard.dart';
import '../../Widgets/listTileDashboardBook.dart';

class BookCarousel extends StatefulWidget {
  final List<Widget> bookWidgets;

  const BookCarousel({Key? key, required this.bookWidgets}) : super(key: key);

  @override
  _BookCarouselState createState() => _BookCarouselState();
}

class _BookCarouselState extends State<BookCarousel> {
  int _currentBookPage = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 200,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: widget.bookWidgets.isEmpty
          ? Center(
        child: Text(
          'No books available',
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
            itemCount: widget.bookWidgets.length,
            onPageChanged: (index) {
              setState(() {
                _currentBookPage = index;
              });
            },
            itemBuilder: (context, index) {
              BookTemplate book = widget.bookWidgets[index] as BookTemplate;
              return BookCard(
                bookId: book.id,
                bookName: book.name,
                bookPrice: book.price,
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios,
              color: _currentBookPage == 0
                  ? Colors.transparent
                  : Colors.black,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios,
              color: _currentBookPage == widget.bookWidgets.length - 1
                  ? Colors.transparent
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
