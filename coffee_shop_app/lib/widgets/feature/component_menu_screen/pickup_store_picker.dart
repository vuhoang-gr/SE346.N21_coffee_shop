import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../screens/store_selection_screen.dart';
import '../../../services/blocs/cart_button/cart_button_state.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

class PickupStorePicker extends StatelessWidget {
  const PickupStorePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartButtonBloc, CartButtonState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () =>
            Navigator.of(context).pushNamed(StoreSelectionScreen.routeName),
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
                    child: Image.asset(
                      "assets/images/pickup_small_icon.png",
                      fit: BoxFit.fill,
                    )),
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
                      state.selectedStore?.address.toString() ??
                          "Select the store",
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
    });
  }
}
