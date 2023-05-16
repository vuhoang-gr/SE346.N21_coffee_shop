import 'package:coffee_shop_app/widgets/feature/menu_screen/skeleton/product_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../utils/constants/dimension.dart';

class PickupMenuSkeleton extends StatelessWidget {
  const PickupMenuSkeleton({super.key});

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
                      lines: 2,
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
