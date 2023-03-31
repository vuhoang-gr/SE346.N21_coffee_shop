import 'package:flutter/cupertino.dart';

import '../../screens/delivery_menu_screen.dart';
import '../../screens/pickup_menu_screen.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';

class OrderTypePicker extends StatelessWidget {
  const OrderTypePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: CupertinoColors.white),
      padding: EdgeInsets.symmetric(
        horizontal: Dimension.width16,
        vertical: Dimension.height16,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(PickupMenuScreen.routeName);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Dimension.width108,
                    height: Dimension.height72,
                    child: Image.asset(
                      "assets\\images\\pickup_icon.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height8,
                  ),
                  Text(
                    "Store pickup",
                    style: AppText.style.mediumBlack16,
                  ),
                  Text(
                    "Best quality",
                    style: AppText.style.regularGrey14,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: Dimension.width16,
          ),
          Container(
            height: Dimension.height48,
            width: Dimension.width1,
            color: AppColors.greyBoxColor,
          ),
          SizedBox(
            width: Dimension.width16,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(DeliveryMenuScreen.routeName);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Dimension.width108,
                    height: Dimension.height72,
                    child: Image.asset(
                      "assets\\images\\delivery_icon.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height8,
                  ),
                  Text(
                    "Delivery",
                    style: AppText.style.mediumBlack16,
                  ),
                  Text(
                    "Always on time",
                    style: AppText.style.regularGrey14,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
