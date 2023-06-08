import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/widgets/global/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

import '../../../utils/constants/dimension.dart';

class StoreDetailSkeleton extends StatelessWidget {
  const StoreDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            CustomAppBar(
              color: AppColors.backgroundColor,
            ),
            Expanded(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: Dimension.height16,
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.symmetric(
                      horizontal: Dimension.width16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SkeletonItem(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                  width: double.infinity,
                                  height:
                                      Dimension.width - Dimension.height16 * 2,
                                  borderRadius: BorderRadius.circular(0))),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                Dimension.width16,
                                Dimension.height12,
                                Dimension.width16,
                                Dimension.height16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: SkeletonParagraph(
                                          style: SkeletonParagraphStyle(
                                              lines: 2,
                                              spacing: 4,
                                              padding: EdgeInsets.zero,
                                              lineStyle: SkeletonLineStyle(
                                                randomLength: true,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                height: Dimension.height20,
                                                minLength: Dimension.width / 2,
                                                maxLength:
                                                    Dimension.width * 3 / 5,
                                              ))),
                                    ),
                                    SkeletonAvatar(
                                        style: SkeletonAvatarStyle(
                                            width: Dimension.height24,
                                            height: Dimension.height24,
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.symmetric(horizontal: Dimension.width16),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimension.width16,
                        vertical: Dimension.height16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SkeletonItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      width: Dimension.width108,
                                      height: Dimension.height72,
                                      borderRadius: BorderRadius.circular(8))),
                              SizedBox(
                                height: Dimension.height4,
                              ),
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  width: Dimension.width / 4,
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
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SkeletonAvatar(
                                  style: SkeletonAvatarStyle(
                                      width: Dimension.width108,
                                      height: Dimension.height72,
                                      borderRadius: BorderRadius.circular(8))),
                              SizedBox(
                                height: Dimension.height4,
                              ),
                              SkeletonLine(
                                style: SkeletonLineStyle(
                                  width: Dimension.width / 4,
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
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height8,
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.symmetric(horizontal: Dimension.width16),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimension.width16,
                        vertical: Dimension.height16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SkeletonItem(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              width: Dimension.width / 4,
                              height: Dimension.height20,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(
                            height: Dimension.height8,
                          ),
                          SkeletonParagraph(
                              style: SkeletonParagraphStyle(
                                  lines: 5,
                                  spacing: 4,
                                  padding: EdgeInsets.zero,
                                  lineStyle: SkeletonLineStyle(
                                      randomLength: true,
                                      borderRadius: BorderRadius.circular(8),
                                      height: Dimension.height20,
                                      minLength: Dimension.width))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
