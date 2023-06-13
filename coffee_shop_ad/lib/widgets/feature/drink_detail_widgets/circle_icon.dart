import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color disabledColor;
  final double size;
  final double iconSize;
  final bool isEnable;
  final VoidCallback onTap;

  const CircleIcon(
      {super.key,
      required this.icon,
      required this.onTap,
      this.iconColor = const Color.fromARGB(255, 30, 155, 243),
      this.backgroundColor = const Color(0xFFfcf4e4),
      this.disabledColor = const Color.fromRGBO(221, 221, 227, 1),
      this.size = 0,
      this.isEnable = true,
      this.iconSize = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnable ? onTap : () {},
      child: Container(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        width: size == 0 ? Dimension.height40 : size,
        height: size == 0 ? Dimension.height40 : size,
        decoration: BoxDecoration(
            border: Border.all(
                color: isEnable ? iconColor : disabledColor, width: 1),
            borderRadius: BorderRadius.circular(
                size == 0 ? Dimension.height40 : size / 2),
            color: backgroundColor),
        child: Icon(
          icon,
          color: isEnable ? iconColor : disabledColor,
          size: iconSize == 0 ? Dimension.height16 : iconSize,
        ),
      ),
    );
  }
}
