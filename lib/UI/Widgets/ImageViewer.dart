import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

//Convert
/// A screen that displays a full-screen preview of an image from a URL.
///
/// This screen is designed to display an image fetched from the internet in full screen.
/// The screen has a black background to enhance the visibility of the image and includes
/// an error icon if the image fails to load.
///
/// ## Parameters:
/// - `imageUrl`: The URL of the image to be displayed.
///
/// ## Actions:
/// - The image is displayed in the center of the screen with a fit style of `BoxFit.contain`.
/// - An error icon is displayed if the image fails to load.
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