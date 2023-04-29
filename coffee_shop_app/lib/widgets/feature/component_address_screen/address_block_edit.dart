import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../screens/address_screen.dart';
import '../../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../../services/models/delivery_address.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

class AddressBlockEdit extends StatelessWidget {
  final DeliveryAddress deliveryAddress;
  final int index;
  const AddressBlockEdit(
      {super.key, required this.deliveryAddress, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartButtonBloc, CartButtonState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () {
          BlocProvider.of<CartButtonBloc>(context).add(
              ChangeSelectedDeliveryAddress(
                  selectedDeliveryAddress: deliveryAddress));
          Navigator.of(context).pop();
        },
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white),
          padding: EdgeInsets.fromLTRB(
              Dimension.width16, Dimension.height4, 0, Dimension.height4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: Dimension.height24,
                        width: Dimension.height24,
                        alignment: Alignment.center,
                        margin: EdgeInsets.zero,
                        child: IconTheme(
                            data: IconThemeData(
                              size: Dimension.height20,
                              color: AppColors.blueColor,
                            ),
                            child: const FaIcon(FontAwesomeIcons.locationDot))),
                    SizedBox(
                      width: Dimension.height8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deliveryAddress.address.toString(),
                            textAlign: TextAlign.center,
                            style: AppText.style.mediumBlack14,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  deliveryAddress.nameReceiver,
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
                                  child: const Icon(Icons.circle)),
                              SizedBox(
                                width: Dimension.width8,
                              ),
                              Text(
                                deliveryAddress.phone,
                                textAlign: TextAlign.left,
                                style: AppText.style.regularGrey12,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddressScreen.routeName,
                        arguments: {
                          "deliveryAddress": deliveryAddress,
                          "index": index
                        });
                  },
                  icon: IconTheme(
                      data: IconThemeData(
                        size: Dimension.width20,
                        color: AppColors.greyTextColor,
                      ),
                      child: const FaIcon(FontAwesomeIcons.pen)))
            ],
          ),
        ),
      );
    });
  }
}
