import 'package:flutter/material.dart';
import 'dart:math' as math;

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
    _SliverAppBarDelegate({
        @required this.minHeight,
        @required this.maxHeight,
        @required this.child,
    });

    final double minHeight;
    final double maxHeight;
    final Widget child;

    @override
    double get minExtent => minHeight;

    @override
    double get maxExtent => math.max(maxHeight, minHeight);

    @override
    Widget build(
        BuildContext context, double shrinkOffset, bool overlapsContent) {
        return new SizedBox.expand(child: child);
    }

    @override
    bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
        return maxHeight != oldDelegate.maxHeight ||
            minHeight != oldDelegate.minHeight ||
            child != oldDelegate.child;
  }
}

SliverPersistentHeader makeHeader(double minHeight, double maxHeight, Widget childWidget) {
  return SliverPersistentHeader(
    pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: minHeight,
        maxHeight: maxHeight,
        child: childWidget,
    ),
  );
}