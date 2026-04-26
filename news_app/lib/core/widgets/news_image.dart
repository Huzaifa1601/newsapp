import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'animated_skeleton.dart';

class NewsImage extends StatelessWidget {
  const NewsImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => AnimatedSkeleton(
          height: height,
          width: width,
          borderRadius: borderRadius.topLeft.x,
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
