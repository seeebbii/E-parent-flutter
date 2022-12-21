import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class ViewPhoto extends StatefulWidget {
  final List<String> galleryItems;
  int currentPage = 0;
  ViewPhoto(
      {Key? key,
        required this.galleryItems,
        this.currentPage = 0})
      : super(key: key);

  @override
  State<ViewPhoto> createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  final PhotoViewController controller = PhotoViewController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider:  BaseHelper.loadNetworkImageObject(widget.galleryItems[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes:
              PhotoViewHeroAttributes(tag: widget.galleryItems[index]),
              minScale: PhotoViewComputedScale.contained * 0.8,
            );
          },
          itemCount: widget.galleryItems.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: const CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          backgroundDecoration:
          BoxDecoration(color: Colors.black38.withOpacity(0.5)),
          // pageController: widget.pageController,
          onPageChanged: (val) {
            setState(() {
              // widget.currentPage = val;
            });
          },
        ),
        Positioned(
          top: 0,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: IconButton(
                onPressed: () => navigationController.goBack(),
                icon: const Icon(Icons.highlight_off, color: AppTheme.whiteColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}