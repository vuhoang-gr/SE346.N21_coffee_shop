import 'package:coffee_shop_app/screens/store_selection_screen.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/blocs/cart_button/cart_button_state.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

class DeliveryStorePicker extends StatelessWidget {
  const DeliveryStorePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartButtonBloc, CartButtonState>(
        builder: (context, state) {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(StoreSelectionScreen.routeName);
          },
          child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: AppColors.greyBoxColor, width: Dimension.height1),
              ),
              padding: EdgeInsets.symmetric(
                vertical: Dimension.height8,
                horizontal: Dimension.width8,
              ),
              margin: EdgeInsets.symmetric(horizontal: Dimension.width16),
              child: Row(children: [
                SizedBox(
                  width: Dimension.width8,
                ),
                Text(
                  "Store",
                  style: AppText.style.regular,
                ),
                SizedBox(
                  width: Dimension.width8,
                ),
                Container(
                  width: Dimension.width1,
                  height: Dimension.height24,
                  color: AppColors.greyBoxColor,
                ),
                SizedBox(
                  width: Dimension.width8,
                ),
                Expanded(
                    child: Text(state.selectedStore?.address.toString()??"Select the store",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppText.style.regular)),
                SizedBox(
                  width: Dimension.width8,
                ),
                IconTheme(
                    data: IconThemeData(
                      size: Dimension.height20,
                      color: AppColors.greyTextColor,
                    ),
                    child: const FaIcon(FontAwesomeIcons.chevronDown)),
              ])));
    });
  }
}
