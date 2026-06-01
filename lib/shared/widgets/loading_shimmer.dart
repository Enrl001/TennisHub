import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key, this.height, this.width, this.borderRadius = 12});

  final double? height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class CoachCardShimmer extends StatelessWidget {
  const CoachCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: 14, width: 140, color: Colors.white),
                const SizedBox(height: 6),
                Container(height: 12, width: 90, color: Colors.white),
              ])),
            ]),
            const SizedBox(height: 12),
            Container(height: 12, color: Colors.white),
            const SizedBox(height: 6),
            Container(height: 12, width: 200, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
