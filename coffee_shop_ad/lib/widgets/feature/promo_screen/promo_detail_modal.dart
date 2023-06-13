import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/screens/promo/promo_edit.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_event.dart';
import 'package:coffee_shop_admin/services/functions/money_transfer.dart';
import 'package:coffee_shop_admin/services/models/promo.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/global/container_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';

class PromoDetailModal extends StatelessWidget {
  final Promo promo;
  const PromoDetailModal({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: Dimension.width,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                border: Border.all(color: Colors.transparent),
                color: Colors.white,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: IconTheme(
                        data: IconThemeData(size: Dimension.width16),
                        child: Icon(
                          FontAwesomeIcons.x,
                        ))),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: Dimension.width16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Discount ${MoneyTransfer.transferFromDouble(promo.percent * 100)}% bill from ${MoneyTransfer.transferFromDouble(promo.minPrice)}",
                    style: AppText.style.mediumBlack16,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                  SizedBox(
                    height: Dimension.height1,
                    child: ColoredBox(color: AppColors.greyBoxColor),
                  ),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: QrImageView(
                      data: promo.id,
                      version: QrVersions.auto,
                      size: Dimension.width108,
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height8,
                  ),
                  Text(
                    promo.id,
                    style: AppText.style.regularBlack16,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Dimension.height16,
                  ),
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
                                shape:
                                    const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45)))),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EditPromoScreen.routeName, arguments: promo)
                                  .then((value) {
                                Navigator.of(context).pop();
                              });
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
                                shape:
                                    const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45)))),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        content: Builder(builder: (context) {
                                          return SizedBox(
                                            height: Dimension.height160,
                                            width: Dimension.width296,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.bottomCenter,
                                                  height: Dimension.height43,
                                                  padding: EdgeInsets.symmetric(horizontal: Dimension.width16),
                                                  child: Text(
                                                    "Confirm",
                                                    textAlign: TextAlign.center,
                                                    style: AppText.style.boldBlack18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimension.height8,
                                                ),
                                                Container(
                                                    height: Dimension.height37,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Do you want to delete this promo?",
                                                      style: AppText.style.regular,
                                                    )),
                                                SizedBox(
                                                  height: Dimension.height8,
                                                ),
                                                Container(
                                                    height: Dimension.height56,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimension.width16, vertical: Dimension.height8),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: ElevatedButton(
                                                              onPressed: () async {
                                                                QuickAlert.show(
                                                                  context: context,
                                                                  type: QuickAlertType.loading,
                                                                  title: 'Loading',
                                                                  text: 'Deleting your promo...',
                                                                );
                                                                promoReference.doc(promo.id).delete().then((value) {
                                                                  Navigator.of(context).pop();
                                                                  Navigator.of(context).pop();
                                                                  Navigator.of(context).pop();
                                                                  BlocProvider.of<PromoBloc>(context).add(FetchData());
                                                                });
                                                              },
                                                              style: _roundedOutlineButtonStyle,
                                                              child: Text(
                                                                "Yes",
                                                                style: AppText.style.regularBlue16,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          width: Dimension.width8,
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              style: _roundedButtonStyle,
                                                              child: Text(
                                                                "No",
                                                                style: AppText.style.regularWhite16,
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
                  SizedBox(
                    height: Dimension.height1,
                    child: ColoredBox(color: AppColors.greyBoxColor),
                  ),
                  SizedBox(
                    height: Dimension.height6,
                  ),
                  Row(
                    children: [
                      Text(
                        "Time start",
                        style: AppText.style.regularBlack14,
                      ),
                      Expanded(
                          child: Text(
                        DateFormat('HH:mm dd/MM/yyyy').format(promo.dateStart),
                        style: AppText.style.regularBlack14,
                        textAlign: TextAlign.right,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: Dimension.height6,
                  ),
                  Row(
                    children: [
                      Text(
                        "Time expired",
                        style: AppText.style.regularBlack14,
                      ),
                      Expanded(
                          child: Text(
                        DateFormat('HH:mm dd/MM/yyyy').format(promo.dateEnd),
                        style: AppText.style.regularBlack14,
                        textAlign: TextAlign.right,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: Dimension.height6,
                  ),
                  SizedBox(
                    height: Dimension.height1,
                    child: ColoredBox(color: AppColors.greyBoxColor),
                  ),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                  Text(
                    promo.description,
                    style: AppText.style.regularBlack14,
                  ),
                  SizedBox(
                    height: Dimension.height16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _roundedButtonStyle = ButtonStyle(
    elevation: const MaterialStatePropertyAll(0),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimension.height20),
    )),
    backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor));

final _roundedOutlineButtonStyle = ButtonStyle(
    elevation: const MaterialStatePropertyAll(0),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.blueColor, width: 1),
      borderRadius: BorderRadius.circular(Dimension.height20),
    )),
    backgroundColor: const MaterialStatePropertyAll(Colors.white));
