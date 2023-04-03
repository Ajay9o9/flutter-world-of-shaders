import 'package:flutter/material.dart';
import 'package:interactive_gallery/widgets/image_gallery_item.dart';

class GalleryItemPage extends StatelessWidget {
  const GalleryItemPage({
    super.key,
    required this.imagePath,
    required this.heroTag,
  });

  final String imagePath;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragStart: (details) {
          Navigator.of(context).pop();
        },
        child: ImageGalleryItem(
          heroTag: heroTag,
          imagePath: imagePath,
        ),
      ),
    );
  }
}
