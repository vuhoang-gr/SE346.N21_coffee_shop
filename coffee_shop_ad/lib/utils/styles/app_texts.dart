import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:flutter/material.dart';

class AppText {
  static AppText style = AppText._();
  AppText._();
  final regular = TextStyle(fontSize: Dimension.font14, height: 1.5, color: AppColors.blackColor);
  final regularBlack16 = TextStyle(fontSize: Dimension.font16, height: 1.5, color: AppColors.blackColor);
  final regularBlack14 = TextStyle(fontSize: Dimension.font14, height: 1.5, color: AppColors.blackColor);
  final regularBlack14Blur = TextStyle(fontSize: Dimension.font14, height: 1.5, color: AppColors.blackBlurColor);
  final regularGrey16 = TextStyle(fontSize: Dimension.font16, height: 1.5, color: AppColors.greyTextColor);
  final regularGrey14 = TextStyle(fontSize: Dimension.font14, height: 1.5, color: AppColors.greyTextColor);
  final regularGrey12 = TextStyle(fontSize: Dimension.font12, height: 1.5, color: AppColors.greyTextColor);
  final regularGrey10 = TextStyle(fontSize: Dimension.font10, height: 1.5, color: AppColors.greyTextColor);
  final regularBlack10 = TextStyle(fontSize: Dimension.font10, height: 1.5, color: AppColors.blackColor);
  final regularWhite14 = TextStyle(fontSize: Dimension.font14, height: 1.5, color: Colors.white);
  final regularWhite16 = TextStyle(fontSize: Dimension.font16, height: 1.5, color: Colors.white);
  final regularBlue14 = TextStyle(fontSize: Dimension.font14, height: 1.5, color: Colors.blue);
  final regularBlue16 = TextStyle(fontSize: Dimension.font16, height: 1.5, color: Colors.blue);
  final regularOrange18 = TextStyle(fontSize: Dimension.font18, height: 1.5, color: AppColors.orangeColor);
  final regular10 = TextStyle(fontSize: Dimension.font10, height: 1.5);

  final mediumBlack14 = TextStyle(
      fontSize: Dimension.font14,
      height: 1.5,
      textBaseline: TextBaseline.ideographic,
      fontWeight: FontWeight.w500,
      color: AppColors.blackColor);
  final mediumBlack16 =
      TextStyle(fontSize: Dimension.font16, height: 1.5, fontWeight: FontWeight.bold, color: AppColors.blackColor);
  final mediumGrey12 = TextStyle(
    fontSize: Dimension.font12,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(39, 39, 42, 0.7),
  );
  final mediumBlack12 = TextStyle(
    fontSize: Dimension.font12,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );
  final mediumBlue12 = TextStyle(
    fontSize: Dimension.font12,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: AppColors.blueColor,
  );
  final mediumWhite12 = TextStyle(
    fontSize: Dimension.font12,
    height: 1.5,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  final boldBlack14 =
      TextStyle(fontSize: Dimension.font14, height: 1.5, fontWeight: FontWeight.bold, color: AppColors.blackColor);
  final boldBlack16 =
      TextStyle(fontSize: Dimension.font16, height: 1.5, fontWeight: FontWeight.bold, color: AppColors.blackColor);
  final boldBlack18 =
      TextStyle(fontSize: Dimension.font18, height: 1.5, fontWeight: FontWeight.bold, color: AppColors.blackColor);
  final boldBlack14Blur =
      TextStyle(fontSize: Dimension.font14, height: 1.5, color: AppColors.blackBlurColor, fontWeight: FontWeight.bold);
  final boldWhite10 =
      TextStyle(fontSize: Dimension.font10, height: 1.5, fontWeight: FontWeight.bold, color: Colors.white);
}
