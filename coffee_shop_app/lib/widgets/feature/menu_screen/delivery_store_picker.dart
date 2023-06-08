import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/screens/store/store_selection_screen.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/blocs/cart_button/cart_button_state.dart';
import '../../../services/models/location.dart';
import '../../../services/models/store.dart';
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
            LatLng? latLng = initLatLng;
            if (state.selectedDeliveryAddress != null) {
              DeliveryAddress deliveryAddress = state.selectedDeliveryAddress!;
              MLocation address = deliveryAddress.address;
              latLng = LatLng(address.lat, address.lng);
            }
            
            Navigator.of(context)
                .pushNamed(StoreSelectionScreen.routeName, arguments: {
              "latLng": latLng,
              "isPurposeForShowDetail": false,
            }).then((value) {
              if (value != null && value is Store) {
                BlocProvider.of<CartButtonBloc>(context)
                    .add(ChangeSelectedStoreButNotUse(selectedStore: value));
              }
            });
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
                  "Cửa hàng",
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
                    child: Text(
                        state.selectedStore?.address.formattedAddress ??
                            "Chọn cửa hàng",
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
