import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/dimension.dart';

class ApplyCouponTextfield extends StatelessWidget {
  const ApplyCouponTextfield({super.key, required this.closeBox});
  final VoidCallback closeBox;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimension.height8,
        ),
        Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                child: const Padding(
                    padding: EdgeInsets.all(3), child: Icon(Icons.close)),
                onTap: () {
                  closeBox();
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Apply coupon',
                style: AppText.style.boldBlack16,
              ),
            )
          ],
        ),
        const Divider(
          thickness: 1,
          color: AppColors.greyBoxColor,
        ),
        SizedBox(
          height: Dimension.height16,
        ),
        TextField(
          autofocus: true,
          style: TextStyle(height: 1.5, fontSize: Dimension.font14),
          decoration: InputDecoration(
              suffix: GestureDetector(
                onTap: () {
                  closeBox();
                },
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: Dimension.height16,
                        height: 1.5,
                        color: AppColors.greyTextField),
                    children: <TextSpan>[
                      const TextSpan(text: '|  '),
                      TextSpan(
                          text: 'Apply',
                          style: TextStyle(
                              color: Colors.blue, fontSize: Dimension.font14)),
                    ],
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                  top: Dimension.height8,
                  left: Dimension.height16,
                  right: Dimension.height16),
              hintText: 'Enter your code',
              hintStyle: const TextStyle(color: AppColors.greyTextColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.black)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide:
                      const BorderSide(color: AppColors.greyTextField))),
        ),
        SizedBox(
          height: Dimension.height16,
        ),
      ],
    );
  }
}
