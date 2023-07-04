import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_admin/services/models/store.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/feature/drink_detail_widgets/icon_widget_row.dart';
import 'package:coffee_shop_admin/widgets/feature/store/store_detail_card.dart';
import 'package:coffee_shop_admin/widgets/global/container_card.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';

class StoreDetail extends StatelessWidget {
  const StoreDetail({super.key, required this.store});
  final Store store;

  void _handleOnTapDeleteStore(BuildContext context) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Delete ${store.sb}?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: AppColors.blueColor,
      confirmBtnTextStyle: AppText.style.regularWhite16,
      cancelBtnTextStyle: AppText.style.regularBlue16,
      onConfirmBtnTap: () async {
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Loading',
          text: 'Deleting ${store.sb}',
        );

        try {
          await storeReference.doc(store.id).delete().then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            BlocProvider.of<StoreStoreBloc>(context).add(FetchData());

            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Completed Successfully!',
              confirmBtnText: "Ok",
              confirmBtnColor: AppColors.blueColor,
            );
          });
        } catch (e) {
          print("Something wrong when delete size");
          print(e);
        }
      },
    );
  }

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
                leading: Text(
                  'Store: ${store.sb}',
                  style: AppText.style.regularBlack16,
                ),
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
                        padding: EdgeInsets.only(left: Dimension.height16, right: Dimension.height16),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding: EdgeInsets.only(left: Dimension.height16, right: Dimension.height16),
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
                                              borderRadius: BorderRadius.all(Radius.circular(45)))),
                                      onPressed: () {
                                        print("Press EDIT store");
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                              borderRadius: BorderRadius.all(Radius.circular(45)))),
                                      onPressed: () => _handleOnTapDeleteStore(context),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
