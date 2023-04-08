import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../global/container_card.dart';
import 'favorite_store_icon.dart';

class TempStoreListItem extends StatelessWidget {
  final String shortName;
  final String address;
  final bool isFavoriteStore;
  const TempStoreListItem({super.key, required this.shortName, required this.address, this.isFavoriteStore = false});

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
                shortName,
                style: AppText.style.mediumBlack14.copyWith(height: 1),
              ),
              SizedBox(
                height: Dimension.height4,
              ),
              Text(
                address,
                style: AppText.style.regularGrey12,
              ),
            ],
          ),
        ]));
  }
}
