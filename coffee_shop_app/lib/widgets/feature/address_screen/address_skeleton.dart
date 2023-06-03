import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletons/skeletons.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';

class AddressSkeleton extends StatelessWidget {
  const AddressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      padding: EdgeInsets.fromLTRB(
          Dimension.width16, Dimension.height8, 0, Dimension.height8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SkeletonItem(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          width: Dimension.height24,
                          height: Dimension.height24)),
                  SizedBox(
                    width: Dimension.height8,
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
                          height: Dimension.height20,
                          minLength: Dimension.width / 4,
                          maxLength: Dimension.width / 2,
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
