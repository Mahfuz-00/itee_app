import 'package:flutter/material.dart';

class ListCardView extends StatefulWidget {
  final List<Widget> items;

  const ListCardView({Key? key, required this.items}) : super(key: key);

  @override
  _ListCardViewState createState() => _ListCardViewState();
}

class _ListCardViewState extends State<ListCardView> {
  int _currentListPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Stack(
        children: [
          PageView.builder(
            controller: PageController(viewportFraction: 0.95),
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentListPage = index;
              });
            },
            itemBuilder: (context, index) {
              return widget.items[index];
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios,
              color: _currentListPage == 0 ? Colors.transparent : Colors.grey,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios,
              color: _currentListPage == widget.items.length - 1
                  ? Colors.transparent
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
