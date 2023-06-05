import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../screens/customer_address/address_listing_screen.dart';
import '../../../services/apis/auth_api.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

class AddressPicker extends StatelessWidget {
  const AddressPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartButtonBloc, CartButtonState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(AddressListingScreen.routeName);
        },
        child: Container(
          alignment: Alignment.center,
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
                    height: Dimension.height40,
                    child: Image.asset(
                      "assets/images/delivery_small_icon.png",
                      fit: BoxFit.fitHeight,
                    )),
                SizedBox(
                  width: Dimension.width8,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Giao hàng đến",
                      style: AppText.style.regular,
                    ),
                    SizedBox(
                      height: Dimension.height4,
                    ),
                    Text(
                      state.selectedDeliveryAddress?.address.formattedAddress ??
                          "Chọn địa chỉ",
                      style: AppText.style.boldBlack14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: Dimension.height4,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            state.selectedDeliveryAddress?.nameReceiver ??
                                AuthAPI.currentUser!.name,
                            textAlign: TextAlign.left,
                            style: AppText.style.regularGrey12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: Dimension.width8,
                        ),
                        IconTheme(
                            data: IconThemeData(
                              size: Dimension.height4,
                              color: AppColors.greyTextColor,
                            ),
                            child: const Icon(CupertinoIcons.circle_fill)),
                        SizedBox(
                          width: Dimension.width8,
                        ),
                        Text(
                          state.selectedDeliveryAddress?.phone ?? AuthAPI.currentUser!.phoneNumber,
                          textAlign: TextAlign.left,
                          style: AppText.style.regularGrey12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
