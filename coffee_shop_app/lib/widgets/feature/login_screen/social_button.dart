import 'package:coffee_shop_app/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_app/services/models/user.dart';
import 'package:coffee_shop_app/utils/constants/social_enum.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../services/apis/auth_api.dart';
import '../../../services/blocs/app_cubit/app_cubit.dart';
import 'information_dialog.dart';

// ignore: must_be_immutable
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
    pressed() async {
      if (onPressed != null) return onPressed;

      context.read<AppCubit>().changeState(AppLoading());

      User? user;
      if (type == Social.google) {
        user = await AuthAPI().googleLogin();
      } else if (type == Social.facebook) {
        user = await AuthAPI().facebookLogin();
      }

      if (user == null && context.mounted) {
        context.read<AuthBloc>().add(SocialLogin(user: user));
        return null;
      }
      if (context.mounted) {
        context.read<AppCubit>().changeState(AppLoaded());
        await Future.delayed(const Duration(milliseconds: 2));
      }
      // await AuthAPI().signOut();

      if (context.mounted) {
        if (user!.phoneNumber == "No Phone Number") {
          var check = await showDialog(
            context: context,
            builder: (context) => InformationDialog(
              user: user,
            ),
          );
          if (!check) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')));
              await AuthAPI().signOut();
              return null;
            }
          }
        }
        if (context.mounted) {
          context.read<AuthBloc>().add(SocialLogin(user: user));
        }
      }
    }

    return TouchableOpacity(
      onTap: pressed,
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
