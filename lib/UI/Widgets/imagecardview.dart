import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Data/Models/imagemodel.dart';

class ImageCarousel extends StatefulWidget {
  final List<ImageModel> items;

  const ImageCarousel({Key? key, required this.items}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                print(_currentPage);
              });
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final String fullImageUrl =
                  'https://www.bcc.touchandsolve.com' + item.imageUrl;
              print(fullImageUrl);
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CachedNetworkImage(
                          imageUrl: fullImageUrl,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: fullImageUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => Center(
                    child: Icon(Icons.error),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios,
              color: _currentPage == 0 ? Colors.transparent : Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios,
              color: _currentPage == widget.items.length - 1
                  ? Colors.transparent
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
