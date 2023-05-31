import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/screens/main_page.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../services/blocs/cart_button/cart_button_bloc.dart';
// import '../../services/blocs/cart_button/cart_button_event.dart';
// import '../../services/blocs/cart_button/cart_button_state.dart';
import '../../services/models/store.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/button.dart';
import '../../widgets/feature/product_detail_widgets/icon_widget_row.dart';
import '../../widgets/feature/store/store_detail_card.dart';
import '../../widgets/global/container_card.dart';
import '../../widgets/global/custom_app_bar.dart';

class StoreDetail extends StatelessWidget {
  StoreDetail({super.key, required this.store});
  final Store store;
  final _roundedButtonStyle = ButtonStyle(
      elevation: const MaterialStatePropertyAll(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimension.height20),
      )),
      backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor));

  final _roundedOutlineButtonStyle = ButtonStyle(
      elevation: const MaterialStatePropertyAll(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.blueColor, width: 1),
        borderRadius: BorderRadius.circular(Dimension.height20),
      )),
      backgroundColor: const MaterialStatePropertyAll(Colors.white));

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              CustomAppBar(
                color: Colors.white,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StoreDetailCard(
                        store: store,
                      ),
                      SizedBox(
                        height: Dimension.height12,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Dimension.height16,
                            right: Dimension.height16),
                        child: Column(
                          children: [
                            SizedBox(
                              height: Dimension.height12,
                            ),
                            ContainerCard(
                              horizontalPadding: Dimension.height16,
                              verticalPadding: Dimension.height24,
                              child: Column(
                                children: [
                                  IconWidgetRow(
                                    icon: CupertinoIcons.phone_fill,
                                    iconColor: AppColors.greenColor,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Phone number',
                                          style: AppText.style.regular,
                                        ),
                                        SizedBox(
                                          height: Dimension.height4,
                                        ),
                                        Text(
                                          store.phone,
                                          style: AppText.style.boldBlack14,
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: AppColors.greyBoxColor,
                                  ),
                                  IconWidgetRow(
                                    icon: Icons.location_pin,
                                    iconColor: Colors.blue,
                                    child: Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Address',
                                            style: AppText.style.regular,
                                          ),
                                          SizedBox(
                                            height: Dimension.height4,
                                          ),
                                          Text(
                                            store.address.formattedAddress,
                                            style: AppText.style.boldBlack14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Dimension.height16,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Dimension.height16,
                            right: Dimension.height16),
                        child: Column(
                          children: [
                            ContainerCard(
                              horizontalPadding: Dimension.height24,
                              verticalPadding: Dimension.height10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          // elevation: 0,
                                          fixedSize: Size.fromWidth(120),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(45)))),
                                      onPressed: () {
                                        print("Press EDIT store");
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.create_outlined,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Edit',
                                            style: AppText.style.regularWhite16,
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          // elevation: 0,
                                          fixedSize: Size.fromWidth(120),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(45)))),
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  content: Builder(
                                                      builder: (context) {
                                                    return SizedBox(
                                                      height:
                                                          Dimension.height160,
                                                      width: Dimension.width296,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            height: Dimension
                                                                .height43,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        Dimension
                                                                            .width16),
                                                            child: Text(
                                                              "Confirm",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: AppText
                                                                  .style
                                                                  .boldBlack18,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: Dimension
                                                                .height8,
                                                          ),
                                                          Container(
                                                              height: Dimension
                                                                  .height37,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "Do you want to delate this store?",
                                                                style: AppText
                                                                    .style
                                                                    .regular,
                                                              )),
                                                          SizedBox(
                                                            height: Dimension
                                                                .height8,
                                                          ),
                                                          Container(
                                                              height: Dimension
                                                                  .height56,
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimension
                                                                          .width16,
                                                                  vertical:
                                                                      Dimension
                                                                          .height8),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: ElevatedButton(
                                                                        onPressed: () async {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection("Store")
                                                                              .doc(store.id)
                                                                              .delete();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          BlocProvider.of<StoreStoreBloc>(context)
                                                                              .add(FetchData());
                                                                        },
                                                                        style: _roundedOutlineButtonStyle,
                                                                        child: Text(
                                                                          "Yes",
                                                                          style: AppText
                                                                              .style
                                                                              .regularBlue16,
                                                                        )),
                                                                  ),
                                                                  SizedBox(
                                                                    width: Dimension
                                                                        .width8,
                                                                  ),
                                                                  Expanded(
                                                                    child: ElevatedButton(
                                                                        onPressed: () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        style: _roundedButtonStyle,
                                                                        child: Text(
                                                                          "No",
                                                                          style: AppText
                                                                              .style
                                                                              .regularWhite16,
                                                                        )),
                                                                  )
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    );
                                                  }));
                                            });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Delete',
                                            style: AppText.style.regularWhite16,
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Dimension.height16,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
