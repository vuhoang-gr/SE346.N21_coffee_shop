import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class PromoSkeleton extends StatelessWidget {
  const PromoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: SkeletonItem(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Dimension.height8),
            child: SkeletonAvatar(style: SkeletonAvatarStyle(width: Dimension.height68, height: Dimension.height68)),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(Dimension.height8),
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
            ),
          )),
        ],
      )),
    );
  }
}
