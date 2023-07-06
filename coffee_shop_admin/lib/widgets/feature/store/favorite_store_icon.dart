import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoriteStoreIcon extends StatelessWidget {
  const FavoriteStoreIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        SizedBox(
          height: Dimension.height24,
          width: Dimension.width24,
        ),
        Positioned(
          child: SizedBox(
              height: Dimension.height20,
              width: Dimension.width20,
              child: IconTheme(
                  data: IconThemeData(
                    size: Dimension.width20,
                    color: AppColors.greyIconColor,
                  ),
                  child: const FaIcon(FontAwesomeIcons.store))),
        ),
        Positioned(
          bottom: Dimension.height7,
          right: Dimension.width8,
          child: SizedBox(
              height: Dimension.height8,
              width: Dimension.width8,
              child: IconTheme(
                  data: IconThemeData(
                    size: Dimension.width16,
                    color: CupertinoColors.white,
                  ),
                  child: const FaIcon(FontAwesomeIcons.solidHeart))),
        ),
        Positioned(
          bottom: Dimension.height6,
          right: Dimension.width6,
          child: SizedBox(
              height: Dimension.height8,
              width: Dimension.width8,
              child: IconTheme(
                  data: IconThemeData(
                    size: Dimension.width12,
                    color: AppColors.greyIconColor,
                  ),
                  child: const FaIcon(FontAwesomeIcons.solidHeart))),
        )
      ],
    );
  }
}
