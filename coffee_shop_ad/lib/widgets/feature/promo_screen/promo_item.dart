import 'package:coffee_shop_admin/services/models/promo.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/feature/promo_screen/promo_detail_modal.dart';
import 'package:coffee_shop_admin/widgets/global/aysncImage/async_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/functions/money_transfer.dart';

class PromoItem extends StatelessWidget {
  final Promo promo;
  const PromoItem({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (builder) {
          return PromoDetailModal(
            promo: promo,
          );
        },
      ),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            children: [
              IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(Dimension.height8),
                  child: SizedBox(
                    height: Dimension.height68,
                    width: Dimension.height68,
                    child: Stack(
                      children: [
                        SizedBox(child: AsyncImage(src: _getImage())),
                        Center(
                          child: Text(
                            "${MoneyTransfer.transferFromDouble(promo.percent * 100)}%",
                            style: AppText.style.regularOrange18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Dimension.width2,
                child: ColoredBox(color: AppColors.greyBoxColor),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimension.height8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Text(
                          "Giảm ${MoneyTransfer.transferFromDouble(promo.percent * 100)}% đơn ${MoneyTransfer.transferFromDouble(promo.minPrice)}",
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.style.regularBlack16,
                        ),
                      ),
                      Text(
                        promo.id,
                        style: AppText.style.mediumBlack14,
                      ),
                      Text(
                        "Expired in: ${DateFormat('HH:mm dd/MM/yyyy').format(promo.dateEnd)}",
                        style: AppText.style.regularGrey12,
                      ),
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

  String _getImage() {
    if (promo.forNewCustomer) {
      return "https://firebasestorage.googleapis.com/v0/b/coffee-shop-app-437c7.appspot.com/o/promo%2FNewCustomer.png?alt=media&token=bd0fde1b-76ce-4a1d-88f7-b9536aeeb767&_gl=1*1e6ij5z*_ga*NjUyMDc4ODQxLjE2Nzc2NjE1OTI.*_ga_CW55HF8NVT*MTY4NTY0Mjk4Mi4yNy4xLjE2ODU2NDMwOTUuMC4wLjA.";
    } else {
      return "https://firebasestorage.googleapis.com/v0/b/coffee-shop-app-437c7.appspot.com/o/promo%2FAll.png?alt=media&token=c16c732d-5eab-48bc-b111-c84ff835dc00&_gl=1*dqk2qm*_ga*ODY4OTcyNTgyLjE2ODU2OTgxMTU.*_ga_CW55HF8NVT*MTY4NTgzMzY0My4xNi4xLjE2ODU4MzQwMDcuMC4wLjA.";
    }
  }
}
