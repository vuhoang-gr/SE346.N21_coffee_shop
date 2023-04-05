import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../utils/constants/dimension.dart';

class OrderStatusLabel extends StatelessWidget {
  const OrderStatusLabel(
      {super.key,
      required this.backgroundColor,
      required this.foregroundColor,
      required this.text});

  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimension.height4, horizontal: Dimension.height12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: backgroundColor),
      child: Text(
        text,
        style: TextStyle(
            fontSize: Dimension.font14,
            fontWeight: FontWeight.w500,
            color: foregroundColor),
      ),
    );
  }
}
