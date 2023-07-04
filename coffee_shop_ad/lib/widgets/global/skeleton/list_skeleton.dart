import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/widgets/global/skeleton/item_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

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
              children: [],
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
