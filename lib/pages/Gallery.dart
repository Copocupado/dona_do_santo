import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryWidget extends StatefulWidget {
  final int index;
  final PageController pageController;
  final List<String> images;

  GalleryWidget({
    super.key,
    required this.index,
    required this.images,
  }) : pageController = PageController(initialPage: index);

  @override
  State<StatefulWidget> createState() => GalleryWidgetState();
}

class GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
        itemCount: widget.images.length,
        pageController: widget.pageController,
        enableRotation: true,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.images[index]));
        });
  }
}