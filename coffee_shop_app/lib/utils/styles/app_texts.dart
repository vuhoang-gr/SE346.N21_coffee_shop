
import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../constants/dimension.dart';

class AppText {
  static AppText style = AppText._();
  AppText._();
  final regular = TextStyle(
      fontSize: Dimension.font14, height: 1.5, color: AppColors.blackColor);
  final regularBlack14Blur = TextStyle(
      fontSize: Dimension.font14, height: 1.5, color: AppColors.blackBlurColor);
  final regularGrey14 = TextStyle(
      fontSize: Dimension.font14, height: 1.5, color: AppColors.greyTextColor);
  final regularGrey12 = TextStyle(
      fontSize: Dimension.font12, height: 1.5, color: AppColors.greyTextColor);
  final regularBlack10 = TextStyle(
      fontSize: Dimension.font10, height: 1.5, color: AppColors.blackColor);
  final regularWhite16 = TextStyle(
      fontSize: Dimension.font16, height: 1.5, color: Colors.white);
  final regularBlue16 = TextStyle(
      fontSize: Dimension.font16, height: 1.5, color: Colors.blue);
  final mediumBlack14 = TextStyle(
      fontSize: Dimension.font14,
      height: 1.5,
      fontWeight: FontWeight.w500,
      color: AppColors.blackColor);
  final mediumBlack16 = TextStyle(
      fontSize: Dimension.font16,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor);
  final boldBlack14 = TextStyle(
      fontSize: Dimension.font14,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor);
  final boldBlack16 = TextStyle(
      fontSize: Dimension.font16,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor);
  final boldBlack18 = TextStyle(
      fontSize: Dimension.font18,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor);
  final boldBlack14Blur = TextStyle(
      fontSize: Dimension.font14,
      height: 1.5,
      color: AppColors.blackBlurColor,
      fontWeight: FontWeight.bold);
  final boldWhite10 = TextStyle(
      fontSize: Dimension.font10,
      height: 1.5,
      fontWeight: FontWeight.bold,
      color: Colors.white);
}
