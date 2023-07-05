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

  void _handleOnTapDeletePromo(BuildContext context) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Delete ${promo.id}?',
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
          text: 'Deleting...',
        );

        try {
          await promoReference.doc(promo.id).delete().then((value) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            BlocProvider.of<PromoBloc>(context).add(FetchData());

            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Completed Successfully!',
              confirmBtnText: "Ok",
              confirmBtnColor: AppColors.blueColor,
            );
          });
        } catch (e) {
          print("Something wrong when delete promo");
          print(e);
        }
      },
    );
  }

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
                                fixedSize: Size.fromWidth(120),
                                shape:
                                    const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(45)))),
                            onPressed: promo.isActive
                                ? null
                                : () {
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
                            onPressed: () => _handleOnTapDeletePromo(context),
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
