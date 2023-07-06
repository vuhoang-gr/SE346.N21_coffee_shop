import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoundedButton extends StatelessWidget {
  final double width;
  final String label;
  double? height, borderRadius;
  final Color backgroundColor;
  final Widget? child;
  final void Function()? onPressed;

  RoundedButton({
    super.key,
    this.width = double.infinity,
    double height = -1,
    double borderRadius = -1,
    required this.onPressed,
    this.label = "CLICK HERE",
    this.backgroundColor = AppColors.blueColor,
    this.child,
  }) {
    if (height == -1) {
      this.height = Dimension.getHeightFromValue(48);
    } else {
      this.height = height;
    }
    if (borderRadius == -1) {
      this.borderRadius = Dimension.getHeightFromValue(this.height! / 2);
    } else {
      this.borderRadius = borderRadius;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
          ),
        ),
        child: child ?? Text(label),
      ),
    );
  }
}
