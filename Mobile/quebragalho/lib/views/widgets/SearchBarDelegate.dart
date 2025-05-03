// Delegate para a barra de pesquisa
import 'package:flutter/material.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  SearchBarDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SearchBarDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent;
  }
}