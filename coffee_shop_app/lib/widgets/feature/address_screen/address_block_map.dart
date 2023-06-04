import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/screens/customer_address/map_screen.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/apis/auth_api.dart';
import '../../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../../services/models/location.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

class AddressBlock extends StatelessWidget {
  const AddressBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MapScreen.routeName, arguments: initLatLng).then((location) {
          MLocation mLocation = location as MLocation;
          BlocProvider.of<CartButtonBloc>(context).add(
              ChangeSelectedDeliveryAddress(
                  selectedDeliveryAddress: DeliveryAddress(
                      address: mLocation,
                      addressNote: "",
                      nameReceiver: AuthAPI.currentUser!.name,
                      phone: AuthAPI.currentUser!.phoneNumber)));
          Navigator.of(context).pop();
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dimension.height8)),
            color: Colors.white),
        padding: EdgeInsets.symmetric(
            vertical: Dimension.height8, horizontal: Dimension.width16),
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
                      margin: EdgeInsets.fromLTRB(0, Dimension.height4, 0, 0),
                      child: IconTheme(
                          data: IconThemeData(
                            size: Dimension.height20,
                            color: AppColors.blueColor,
                          ),
                          child:
                              const FaIcon(FontAwesomeIcons.mapLocationDot))),
                  SizedBox(
                    width: Dimension.height8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Google map",
                          style: AppText.style.mediumBlack14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Use google map to select your place",
                          style: AppText.style.regularGrey12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Dimension.height8,
            ),
            GestureDetector(
                onTap: () {},
                child: IconTheme(
                    data: IconThemeData(
                      size: Dimension.height20,
                      color: const Color.fromRGBO(128, 128, 137, 1),
                    ),
                    child: const FaIcon(FontAwesomeIcons.chevronRight))),
          ],
        ),
      ),
    );
  }
}
