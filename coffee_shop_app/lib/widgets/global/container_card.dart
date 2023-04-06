import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../utils/constants/dimension.dart';

class ContainerCard extends StatelessWidget {
  ContainerCard(
      {super.key,
      required this.child,
      this.verticalPadding = 0,
      this.horizontalPadding = -1});
  Widget child;
  double verticalPadding;
  double horizontalPadding;

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
