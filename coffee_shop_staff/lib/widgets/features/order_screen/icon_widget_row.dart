import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';

// ignore: must_be_immutable
class IconWidgetRow extends StatelessWidget {
  IconWidgetRow(
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
  Widget child;

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
        Flexible(child: child),
      ],
    );
  }
}
