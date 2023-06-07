import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../../../utils/constants/dimension.dart';

class OrderSkeleton extends StatelessWidget {
  const OrderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: Dimension.height8, horizontal: Dimension.height16),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      padding: EdgeInsets.symmetric(
          horizontal: Dimension.height16, vertical: Dimension.height24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SkeletonItem(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Dimension.height8,
                  ),
                  Expanded(
                      child: SkeletonParagraph(
                    style: SkeletonParagraphStyle(
                        lines: 4,
                        spacing: 4,
                        padding: EdgeInsets.zero,
                        lineStyle: SkeletonLineStyle(
                          randomLength: true,
                          borderRadius: BorderRadius.circular(8),
                          height: Dimension.height20,
                          minLength: Dimension.width / 3,
                          maxLength: Dimension.width * 0.8,
                        )),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
