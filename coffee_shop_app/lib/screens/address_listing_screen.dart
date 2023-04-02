import 'package:flutter/material.dart';

import '../temp/data.dart';
import '../utils/colors/app_colors.dart';
import '../utils/constants/dimension.dart';
import '../utils/styles/app_texts.dart';
import '../widgets/feature/component_address_screen/address_block.dart';
import '../widgets/feature/component_address_screen/address_block_edit.dart';
import '../widgets/global/custom_app_bar.dart';
import 'address_screen.dart';

class AddressListingScreen extends StatelessWidget {
  static String routeName = "/address_listing_screen";
  const AddressListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              children: [
                CustomAppBar(
                  leading: Text(
                    "Deliver to",
                    style: AppText.style.boldBlack18,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: Dimension.height16,
                        horizontal: Dimension.width16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AddressBlock(),
                        SizedBox(
                          height: Dimension.height16,
                        ),
                        Text("Saved places",
                            textAlign: TextAlign.left,
                            style: AppText.style.boldBlack16),
                        ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: Dimension.height12),
                            itemBuilder: (context, index) {
                              return AddressBlockEdit(
                                  address:
                                      Data.addresses[index].address,
                                  name: Data.addresses[index].nameReceiver,
                                  phone: Data.addresses[index].phone);
                            },
                            separatorBuilder: (_, __) =>
                                SizedBox(height: Dimension.height12),
                            itemCount: Data.addresses.length),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: Dimension.height12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AddressScreen.routeName);
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Colors.white),
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimension.height8,
                                  horizontal: Dimension.width16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: Dimension.height24,
                                    width: Dimension.height24,
                                    alignment: Alignment.center,
                                    child: IconTheme(
                                        data: IconThemeData(
                                          size: Dimension.height20,
                                          color: AppColors.blueColor,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                        )),
                                  ),
                                  SizedBox(
                                    width: Dimension.width8,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "New place",
                                    style: AppText.style.boldBlack14,
                                  ))
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
