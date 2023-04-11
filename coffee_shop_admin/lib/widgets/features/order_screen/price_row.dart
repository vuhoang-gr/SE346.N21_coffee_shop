import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/styles/app_texts.dart';

//VHDONE
class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.title,
    required this.price,
  });

  final String title;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppText.style.regularGrey14.copyWith(
            color: Colors.black.withOpacity(0.76),
          ),
        ),
        Text(
          '${NumberFormat("#,##0.00", "en_US").format(price)} đ',
          style: AppText.style.boldBlack14,
        ),
      ],
    );
  }
}
