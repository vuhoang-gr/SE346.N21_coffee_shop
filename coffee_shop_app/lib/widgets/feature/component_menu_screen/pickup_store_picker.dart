import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';
class PickupStorePicker extends StatelessWidget {
  const PickupStorePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: CupertinoColors.white,
        padding: EdgeInsets.symmetric(
          vertical: Dimension.height8,
          horizontal: Dimension.width16,
        ),
        child: Row(children: [
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Dimension.width40,
                height: Dimension.height40,
                child:Image.asset(
                  "assets\\images\\pickup_small_icon.png",
                  fit: BoxFit.fill,
                )
              ),
              SizedBox(
                width: Dimension.width8,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pickup at",
                    style: AppText.style.regular,
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Text(
                    "store address",
                    style: AppText.style.boldBlack14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ))
            ],
          )),
          SizedBox(
            width: Dimension.width8,
          ),
          IconTheme(
              data: IconThemeData(
                size: Dimension.height20,
                color: AppColors.greyTextColor,
              ),
              child: const FaIcon(FontAwesomeIcons.chevronRight)),
        ]),
      ),
    );
  }
}
