import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../screens/address_screen.dart';
import '../../../services/models/address.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

class AddressBlockEdit extends StatelessWidget {
  final Address address;
  final String name;
  final String phone;
  const AddressBlockEdit(
      {super.key,
      required this.address,
      required this.name,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
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
                        address.toString(),
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
                              name,
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
                            phone,
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
          SizedBox(
            width: Dimension.width8,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AddressScreen.routeName,
                    arguments: {
                      "address": address.shortName,
                      "name": name,
                      "phoneNumber": phone
                    });
              },
              child: IconTheme(
                  data: IconThemeData(
                    size: Dimension.height20,
                    color: AppColors.greyTextColor,
                  ),
                  child: const FaIcon(FontAwesomeIcons.pen))),
        ],
      ),
    );
  }
}
