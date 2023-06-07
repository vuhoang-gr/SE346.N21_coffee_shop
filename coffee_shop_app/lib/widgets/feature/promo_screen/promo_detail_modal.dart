import 'package:coffee_shop_app/services/models/promo.dart';
import 'package:coffee_shop_app/widgets/global/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_widget/qr_widget.dart';

import '../../../services/functions/money_transfer.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

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
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
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
                    "Giảm ${MoneyTransfer.transferFromDouble(promo.percent * 100)}% đơn ${MoneyTransfer.transferFromDouble(promo.minPrice)}",
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
                  SizedBox(
                    width: Dimension.width40,
                    child: RoundedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(promo);
                        },
                        height: Dimension.height40,
                        child: Text(
                          "Sử dụng ngay",
                          style: AppText.style.regularWhite16,
                        )),
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
                        "Ngày hết hạn",
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
