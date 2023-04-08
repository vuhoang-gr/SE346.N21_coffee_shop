import 'package:flutter/material.dart';

import '../../utils/constants/dimension.dart';

class ContainerCard extends StatelessWidget {
  const ContainerCard(
      {super.key,
      required this.child,
      this.verticalPadding = 0,
      this.horizontalPadding = -1});
  final Widget child;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimension.height8),
          color: Colors.white),
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal:
              horizontalPadding == -1 ? Dimension.height16 : horizontalPadding),
      child: child,
    );
  }
}
