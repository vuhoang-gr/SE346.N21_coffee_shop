import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../utils/constants/dimension.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimension.width16, vertical: Dimension.height8),
      child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (_, __) {
            return ProductSkeleton();
          },
          separatorBuilder: (_, __) => SizedBox(
                height: Dimension.height16,
              ),
          itemCount: 8),
    );
  }
}

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

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
            child: SkeletonParagraph(
          style: SkeletonParagraphStyle(
              lines: 3,
              spacing: 4,
              padding: EdgeInsets.zero,
              lineStyle: SkeletonLineStyle(
                randomLength: true,
                borderRadius: BorderRadius.circular(8),
                height: Dimension.height20,
                minLength: Dimension.width / 4,
                maxLength: Dimension.width / 2,
              )),
        )),
      ],
    ));
  }
}
