import 'package:flutter/material.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';
import '../../global/buttons/rounded_button.dart';

class ProfileCustomButton extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;
  final void Function()? onPressed;

  const ProfileCustomButton({
    this.icon,
    this.title = 'Your title',
    this.description = 'Your description',
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      onPressed: onPressed,
      borderRadius: Dimension.getHeightFromValue(8),
      backgroundColor: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.blueBackgroundColor,
            child: Icon(
              icon,
              color: AppColors.blueColor,
            ),
          ),
          SizedBox(
            width: Dimension.getWidthFromValue(12),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppText.style.regularBlack10.copyWith(
                  fontSize: 15,
                ),
              ),
              Text(
                description,
                style: AppText.style.regularGrey12.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Icon(
            Icons.arrow_forward_ios,
            color: Color.fromARGB(255, 112, 112, 112),
          ),
        ],
      ),
    );
  }
}