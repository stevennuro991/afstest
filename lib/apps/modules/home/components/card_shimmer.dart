
import 'package:afs_test/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBar extends StatelessWidget {
  const ShimmerBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kPrimaryWhite,
      highlightColor:kPrimaryColor,
      period: const Duration(milliseconds: 1100),
      enabled: true,
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration:
            BoxDecoration(color: kPrimaryWhite, borderRadius: kBoxRadius(20)),
      ),
    );
  }
}

