import 'package:flutter/material.dart';

class Dimension {
  static double height =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  static double width =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double textScale =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).textScaleFactor;

  static double getHeightFromValue(double inputHeight) {
    return (height / 640) * inputHeight;
  }

  static double getWidthFromValue(double inputWidth) {
    return (width / 360) * inputWidth;
  }

  static double heightTimePicker = 120 * width / 375;
  static double addToCart108 = 108 * width / 375;
  static double height150 = getHeightFromValue(150);
  static double height230 = getHeightFromValue(230);
  static double height160 = getHeightFromValue(160);
  static double height120 = getHeightFromValue(120);
  static double height82 = getHeightFromValue(82);
  static double height72 = getHeightFromValue(72);
  static double height68 = getHeightFromValue(68);
  static double height56 = getHeightFromValue(56);
  static double height48 = getHeightFromValue(48);
  static double height45 = getHeightFromValue(45);
  static double height43 = getHeightFromValue(43);
  static double height40 = getHeightFromValue(40);
  static double height37 = getHeightFromValue(37);
  static double height32 = getHeightFromValue(32);
  static double height24 = getHeightFromValue(24);
  static double height20 = getHeightFromValue(20);
  static double height16 = getHeightFromValue(16);
  static double height12 = getHeightFromValue(12);
  static double height18 = getHeightFromValue(18);
  static double height10 = getHeightFromValue(10);
  static double height8 = getHeightFromValue(8);
  static double height7 = getHeightFromValue(7);
  static double height6 = getHeightFromValue(6);
  static double height4 = getHeightFromValue(4);
  static double height2 = getHeightFromValue(2);
  static double height1 = getHeightFromValue(1);

  static double width296 = getWidthFromValue(296);
  static double width108 = getWidthFromValue(108);
  static double width68 = getWidthFromValue(68);
  static double width52 = getWidthFromValue(52);
  static double width40 = getWidthFromValue(40);
  static double width32 = getWidthFromValue(32);
  static double width24 = getWidthFromValue(24);
  static double width20 = getWidthFromValue(20);
  static double width16 = getWidthFromValue(16);
  static double width10 = getHeightFromValue(10);
  static double width12 = getWidthFromValue(12);
  static double width8 = getWidthFromValue(8);
  static double width6 = getWidthFromValue(6);
  static double width4 = getWidthFromValue(4);
  static double width2 = getWidthFromValue(2);
  static double width1 = getWidthFromValue(1);

  static double font18 = getWidthFromValue(18) / textScale;
  static double font16 = getWidthFromValue(16) / textScale;
  static double font14 = getWidthFromValue(14) / textScale;
  static double font12 = getWidthFromValue(12) / textScale;
  static double font10 = getWidthFromValue(10) / textScale;
}
