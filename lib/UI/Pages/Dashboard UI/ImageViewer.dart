import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  ImagePreviewScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}