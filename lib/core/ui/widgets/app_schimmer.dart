import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.margin = EdgeInsets.zero,
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final highlightColor = theme.colorScheme.surface.withValues(alpha: 0.8);

    return Padding(
      padding: margin,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 16,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}

class AppPageShimmer extends StatelessWidget {
  const AppPageShimmer({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 120,
    this.padding = const EdgeInsets.all(20),
    this.spacing = 20,
  });

  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      addSemanticIndexes: false,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (_, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmer(height: itemHeight),
            const SizedBox(height: 12),
            const AppShimmer(height: 18, width: 180),
            const SizedBox(height: 8),
            const AppShimmer(height: 14, width: 220),
          ],
        );
      },
    );
  }
}

class AppSectionShimmer extends StatelessWidget {
  const AppSectionShimmer({
    super.key,
    this.height = 160,
    this.count = 1,
    this.spacing = 12,
    this.margin,
  });

  final double height;
  final int count;
  final double spacing;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        children: List.generate(count, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == count - 1 ? 0 : spacing),
            child: AppShimmer(height: height),
          );
        }),
      ),
    );
  }
}