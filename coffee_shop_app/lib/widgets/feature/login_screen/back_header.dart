import 'package:coffee_shop_app/services/blocs/auth_cubit/auth_cubit.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';

class BackHeader extends StatelessWidget {
  const BackHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TouchableOpacity(
          onTap: () {
            final AuthState current = context.read<AuthCubit>().state;
            if (current is ForgotPassword) {
              context.read<AuthCubit>().changeState(Login());
            } else {
              context.read<AuthCubit>().changeState(SignIn());
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 13, horizontal: 12),
            child: IconTheme(
              data: IconThemeData(size: Dimension.height24),
              child: Icon(
                CupertinoIcons.back,
                color: AppColors.blackColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
