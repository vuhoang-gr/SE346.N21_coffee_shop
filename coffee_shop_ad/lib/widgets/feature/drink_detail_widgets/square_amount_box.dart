import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:flutter/material.dart';

class SquareAmountBox extends StatelessWidget {
  const SquareAmountBox(
      {super.key, required this.child, this.size = 0, this.borderColor = const Color.fromRGBO(221, 221, 227, 1)});

  final Widget child;
  final Color borderColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size == 0 ? Dimension.height40 : size,
      width: size == 0 ? Dimension.height40 : size,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: borderColor)),
      child: child,
    );
  }
}
