import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../utils/colors/app_colors.dart';
import '../../../../utils/constants/dimension.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimension.width16),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimension.height8),
            child: SkeletonItem(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                      width: Dimension.height40,
                      height: Dimension.height40),
                ),
                SizedBox(
                  width: Dimension.width8,
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
                          minLength: Dimension.width / 3,
                          maxLength: Dimension.width * 3 / 4,
                          height: Dimension.height20)),
                )),
              ],
            )),
          ),
          SizedBox(
            height: Dimension.height8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.greyBoxColor, width: 1),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: Dimension.width8, vertical: Dimension.height8),
            child: Row(
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                      width: Dimension.width52, height: Dimension.height20),
                ),
                SizedBox(
                  width: Dimension.width8,
                ),
                Expanded(
                    child: SkeletonLine(
                  style: SkeletonLineStyle(height: Dimension.height20),
                ))
              ],
            ),
          ),
          SizedBox(
            height: Dimension.height16,
          ),
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, __) {
                return ProductSkeleton();
              },
              separatorBuilder: (_, __) => SizedBox(
                    height: Dimension.height16,
                  ),
              itemCount: 5),
        ],
      ),
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
