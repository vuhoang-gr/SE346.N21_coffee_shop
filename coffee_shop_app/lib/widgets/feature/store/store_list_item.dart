import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../global/container_card.dart';
import 'favorite_store_icon.dart';

class StoreListItem extends StatelessWidget {
  final bool isFavoriteStore;
  const StoreListItem({super.key, this.isFavoriteStore = false});

  @override
  Widget build(BuildContext context) {
    return ContainerCard(
        verticalPadding: Dimension.height8,
        horizontalPadding: Dimension.width16,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          isFavoriteStore
              ? FavoriteStoreIcon()
              : SizedBox(
                  height: Dimension.height20,
                  width: Dimension.width20,
                  child: IconTheme(
                    data: IconThemeData(
                      size: Dimension.width20,
                      color: AppColors.greyIconColor,
                    ),
                    child: const FaIcon(FontAwesomeIcons.store),
                  ),
                ),
          SizedBox(
            width: Dimension.width8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SB Van Hanh Mall',
                style: AppText.style.mediumBlack14,
              ),
              SizedBox(
                height: Dimension.height4,
              ),
              Text(
                '11 Su Van Hanh, D.10, HCM city',
                style: AppText.style.regularGrey12,
              ),
            ],
          ),
        ]));
  }
}
