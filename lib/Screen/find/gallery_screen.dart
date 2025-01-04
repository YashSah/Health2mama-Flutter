import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health2mama/Utils/flutter_colour_theams.dart';

import '../../Utils/CommonFuction.dart';
import '../../Utils/flutter_font_style.dart';

class GalleryScreen extends StatelessWidget {
  final List<String> images;

  GalleryScreen({required this.images});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Get the device type
    var valueType = CommonFunction.getMyDeviceType(MediaQuery.of(context));
    var displayType = valueType.toString().split('.').last;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: 8.0.w),
          child: Align(
            alignment: FractionalOffset.centerLeft,
            child: Text(
              "Gallery",
              style: (displayType == 'desktop' || displayType == 'tablet')
                  ? FTextStyle.appTitleStyleTablet
                  : FTextStyle.appBarTitleStyle,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (displayType == 'desktop' || displayType == 'tablet') ? 4.w : screenWidth * 0.03,
              vertical: (displayType == 'desktop' || displayType == 'tablet') ? 2.h : screenWidth * 0.01,
            ),
            child: Image.asset(
              'assets/Images/back.png', // Replace with your image path
              width: (displayType == 'desktop' || displayType == 'tablet') ? 35.w : 35,
              height: (displayType == 'desktop' || displayType == 'tablet') ? 35.h : 35,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (displayType == 'desktop' || displayType == 'tablet') ? 16.w : 12.w,
          vertical: (displayType == 'desktop' || displayType == 'tablet') ? 16.h : 8.h,
        ),
        child: images.isNotEmpty
            ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (displayType == 'desktop') ? 4 : (displayType == 'tablet') ? 3 : 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageView(
                      images: images,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.progressIndicatorColor,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: (displayType == 'desktop' || displayType == 'tablet') ? 50.w : 40.w,
                    ),
                  ),
                ),
              ),
            );
          },
        )
            : Center(
          child: Text(
            'No images available.',
            style: (displayType == 'desktop' || displayType == 'tablet')
                ? FTextStyle.cardSubtitleTab
                : FTextStyle.cardSubtitle,
          ),
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  FullScreenImageView({required this.images, required this.initialIndex});

  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  late PageController _pageController;
  bool _isZooming = false; // Flag to track if zooming is active

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onScaleStart: (_) {
          setState(() {
            _isZooming = true; // Start zooming
          });
        },
        onScaleEnd: (_) {
          setState(() {
            _isZooming = false; // End zooming
          });
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (index) {
            if (!_isZooming) {
              // Only change the page if zooming is not happening
              _pageController.jumpToPage(index);
            }
          },
          itemBuilder: (context, index) {
            return InteractiveViewer(
              panEnabled: true, // Enable panning
              scaleEnabled: true, // Enable scaling (zoom)
              minScale: 0.1, // Minimum zoom level
              maxScale: 4.0, // Maximum zoom level
              child: Center(
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.contain, // Ensures the image is contained within the screen and can be zoomed
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 100.w,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
