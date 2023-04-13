import 'package:coffee_shop_app/utils/constants/social_enum.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  void Function()? onPressed;
  final Social type;

  SocialButton({
    super.key,
    this.onPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: SvgPicture.asset(
          'assets/icons/${type == Social.google ? 'IC_google.svg' : 'IC_facebook.svg'}',
        ),
      ),
    );
  }
}
