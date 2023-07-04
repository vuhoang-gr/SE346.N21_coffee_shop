import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:flutter/material.dart';

class IconWidgetRow extends StatelessWidget {
  const IconWidgetRow(
      {super.key,
      required this.icon,
      required this.child,
      this.size = 0,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.iconColor = Colors.blue});
  final IconData icon;
  final Color iconColor;
  final double size;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: size == 0 ? Dimension.font14 * 2 : size,
        ),
        SizedBox(
          width: Dimension.height8,
        ),
        child,
      ],
    );
  }
}
