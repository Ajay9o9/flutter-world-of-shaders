import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/effects/fisheye_distortion.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_grid.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_grid.dart';

class InteractiveGallery extends StatefulWidget {
  const InteractiveGallery({
    super.key,
    this.urls = const [],
    this.viewportsCrossAxisCount = 3,
    this.enableSnapping = true,
    this.enableAntiFisheye = true,
  });

  final List<String> urls;
  final int viewportsCrossAxisCount;
  final bool enableSnapping;
  final bool enableAntiFisheye;

  @override
  State<InteractiveGallery> createState() => _InteractiveGalleryState();
}

class _InteractiveGalleryState extends State<InteractiveGallery>
    with SingleTickerProviderStateMixin {
  final _distortionAmountNotifier = ValueNotifier<double>(0);
  bool _isInit = true;
  late List<Widget> viewports;

  static const int maxItemsPerViewport = 11;

  List<Widget> _generateViewports() {
    final slicedUrls = widget.urls.slices(maxItemsPerViewport).toList();

    return List.generate(
      slicedUrls.length,
      (urlsSliceIndex) {
        final urlsChunk = slicedUrls[urlsSliceIndex];

        return GalleryGrid(
          urls: urlsChunk.toList(),
        );
      },
    );
  }

  @override
  void initState() {
    viewports = _generateViewports();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      precacheImage(
        Image.asset('assets/gallery/trevi-fountain-thumb.png').image,
        context,
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant InteractiveGallery oldWidget) {
    if (oldWidget.urls != widget.urls ||
        oldWidget.viewportsCrossAxisCount != widget.viewportsCrossAxisCount) {
      viewports = _generateViewports();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final grid = InteractiveGrid(
      viewportWidth: screenSize.width,
      viewportHeight: screenSize.height,
      crossAxisCount: widget.viewportsCrossAxisCount,
      enableSnapping: widget.enableSnapping,
      onScrollStart: () {
        _distortionAmountNotifier.value = 0.9;
      },
      onScrollEnd: () {
        _distortionAmountNotifier.value = 0.0;
      },
      children: viewports,
    );

    return ValueListenableBuilder(
      valueListenable: _distortionAmountNotifier,
      builder: (context, double distortionAmount, Widget? child) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: distortionAmount),
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
          builder: (context, double distortionAmount, Widget? child) {
            return FisheyeDistortion(
              enabled: widget.enableAntiFisheye,
              distortionAmount: distortionAmount,
              child: child!,
            );
          },
          child: child,
        );
      },
      child: grid,
    );
  }
}
