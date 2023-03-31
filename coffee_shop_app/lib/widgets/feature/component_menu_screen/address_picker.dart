import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../screens/address_listing_screen.dart';
import '../../../services/models/delivery_address.dart';
import '../../../temp/data.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

class AddressPicker extends StatelessWidget {
  //TODO: need to check exist address in the db
  final DeliveryAddress _addressPicker = Data.addresses[0];
  AddressPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AddressListingScreen.routeName);
      },
      child: Container(
        height: Dimension.height86,
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
                  width: Dimension.width40,
                  height: Dimension.height40,
                  child: Image.asset(
                    "assets\\images\\delivery_small_icon.png",
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                width: Dimension.width8,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery to",
                    style: AppText.style.regular,
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Text(
                    _addressPicker.address.toString(),
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
                          _addressPicker.nameReceiver,
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
                        _addressPicker.phone,
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
  }
}
