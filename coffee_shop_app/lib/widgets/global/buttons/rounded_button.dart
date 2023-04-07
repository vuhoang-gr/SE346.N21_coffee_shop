import 'package:flutter/material.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';

class RoundedButton extends StatelessWidget {
  final double width;
  final String label;
  double? height, borderRadius;
  final void Function()? onPressed;

  RoundedButton({
    super.key,
    this.width = double.infinity,
    height = -1,
    borderRadius = -1,
    required this.onPressed,
    this.label = "CLICK HERE",
  }) {
    if (height == -1) {
      this.height = Dimension.getHeightFromValue(48);
    }
    if (borderRadius == -1) {
      this.borderRadius = Dimension.getHeightFromValue(48 / 2);
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
          backgroundColor: MaterialStatePropertyAll(AppColors.blueColor),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
