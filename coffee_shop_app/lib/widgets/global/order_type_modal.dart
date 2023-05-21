import 'package:coffee_shop_app/screens/customer_address/address_listing_screen.dart';
import 'package:coffee_shop_app/screens/store/store_selection_screen.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_bloc.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_state.dart';
import 'package:coffee_shop_app/services/functions/calculate_distance.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import '../../services/models/store.dart';
import '../../temp/data.dart';
import '../../utils/styles/app_texts.dart';

class OrderTypeModal extends StatelessWidget {
  const OrderTypeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: Dimension.width,
        child: BlocBuilder<CartButtonBloc, CartButtonState>(
            builder: (context, state) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  color: Colors.white,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: AppColors.greyBoxColor,
                  ))),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimension.width4,
                    vertical: Dimension.height10,
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: Dimension.width,
                        child: Text(
                          "Choose order type",
                          style: AppText.style.boldBlack16,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: IconTheme(
                                  data: IconThemeData(size: Dimension.width16),
                                  child: Icon(
                                    FontAwesomeIcons.x,
                                  ))))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (state.selectedDeliveryAddress == null) {
                    Navigator.of(context)
                        .pushNamed(AddressListingScreen.routeName)
                        .then((_) => Navigator.of(context).pop());
                  } else {
                    BlocProvider.of<CartButtonBloc>(context).add(
                        ChangeSelectedOrderType(
                            selectedOrderType: OrderType.delivery));
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  color: state.selectedOrderType == OrderType.delivery
                      ? AppColors.blueBackgroundColor
                      : Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimension.width8,
                      vertical: Dimension.height8),
                  child: Row(
                    children: [
                      SizedBox(
                        height: Dimension.height40,
                        width: Dimension.height40,
                        child: Image.asset(
                          "assets/images/delivery_small_icon.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: Dimension.width12,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delivery to",
                            style: AppText.style.boldBlack14,
                          ),
                          Text(
                            state.selectedDeliveryAddress?.address
                                    .formattedAddress ??
                                "The products will be delivered to your address",
                            style: AppText.style.regularGrey14,
                          ),
                          Text(
                            state.selectedDeliveryAddress == null
                                ? "${Data.name} ${Data.phone}"
                                : "${state.selectedDeliveryAddress?.nameReceiver} ${state.selectedDeliveryAddress?.phone}",
                            style: AppText.style.regularBlack14,
                          ),
                        ],
                      )),
                      SizedBox(
                        width: Dimension.width12,
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                                context, AddressListingScreen.routeName)
                            .then((_) => Navigator.of(context).pop()),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(AppColors.blueColor),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            elevation: MaterialStatePropertyAll(0.0)),
                        child: Text(
                          "edit",
                          style: AppText.style.regularWhite14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (state.selectedStore == null) {
                    Navigator.of(context)
                        .pushNamed(StoreSelectionScreen.routeName, arguments: {
                      "latLng": initLatLng,
                      "isPurposeForShowDetail": false,
                    }).then((_) => Navigator.of(context).pop());
                  } else {
                    BlocProvider.of<CartButtonBloc>(context).add(
                        ChangeSelectedOrderType(
                            selectedOrderType: OrderType.storePickup));
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  color: state.selectedOrderType == OrderType.delivery
                      ? Colors.white
                      : AppColors.blueBackgroundColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimension.width8,
                      vertical: Dimension.height8),
                  child: Row(
                    children: [
                      SizedBox(
                        height: Dimension.height40,
                        width: Dimension.height40,
                        child: Image.asset(
                          "assets/images/pickup_small_icon.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: Dimension.width12,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pickup at",
                            style: AppText.style.boldBlack14,
                          ),
                          Text(
                            state.selectedStore?.address.formattedAddress ??
                                "You will pick up the product at the store and take it away",
                            style: AppText.style.regularGrey14,
                          ),
                          (state.selectedStore != null && initLatLng != null)
                              ? Text(
                                  "${calculateDistance(state.selectedStore!.address.lat, state.selectedStore!.address.lng, initLatLng!.latitude, initLatLng!.longitude).toStringAsFixed(2)} km",
                                  style: AppText.style.regularBlack14,
                                )
                              : SizedBox.shrink(),
                        ],
                      )),
                      SizedBox(
                        width: Dimension.width12,
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                                context, StoreSelectionScreen.routeName,
                                arguments: initLatLng)
                            .then((value) {
                          if (value != null && value is Store) {
                            BlocProvider.of<CartButtonBloc>(context).add(
                                ChangeSelectedStore(
                                    selectedStore: value));
                          }
                          Navigator.of(context).pop();
                        }),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(AppColors.blueColor),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            elevation: MaterialStatePropertyAll(0.0)),
                        child: Text(
                          "edit",
                          style: AppText.style.regularWhite14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
