/// Represents an image item with a URL and a label.
///
/// This class encapsulates information about an image, including its
/// URL and a descriptive label.
///
/// ### Properties:
/// - [imageUrl]: The URL that contains the image.
/// - [label]: A descriptive label for the image.
class ImageItem {
  final String imageUrl;
  final String label;

  ImageItem({
    required this.imageUrl,
    required this.label,
  });
}
