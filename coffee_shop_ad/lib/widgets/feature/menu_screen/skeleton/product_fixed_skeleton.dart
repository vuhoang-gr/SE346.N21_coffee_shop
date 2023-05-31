import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../utils/constants/dimension.dart';

class ProductFixedSkeleton extends StatelessWidget {
  const ProductFixedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonAvatar(
            style: SkeletonAvatarStyle(
                width: Dimension.height68, height: Dimension.height68)),
        SizedBox(
          width: Dimension.width16,
        ),
        Expanded(
            child: Column(
          children: [
            SkeletonLine(
              style: SkeletonLineStyle(
                width: Dimension.width * 4 / 7,
                height: Dimension.height20,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(
              height: Dimension.height4,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                width: Dimension.width / 3,
                height: Dimension.height20,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(
              height: Dimension.height4,
            ),
            SkeletonLine(
              style: SkeletonLineStyle(
                width: Dimension.width / 2,
                height: Dimension.height20,
                borderRadius: BorderRadius.circular(8),
              ),
            )
          ],
        )),
      ],
    ));
  }
}
