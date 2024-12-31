import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonPlaceholder extends StatelessWidget {
  final double height;
  final double width;

  const SkeletonPlaceholder(
      {super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.onTertiary,
        highlightColor: Theme.of(context).colorScheme.onTertiary.withOpacity(0.5),
        direction: ShimmerDirection.ltr,
        child: Container(
          color: Colors.grey[300],
          height: height,
          width: width,
        ),
      ),
    );
  }
}
