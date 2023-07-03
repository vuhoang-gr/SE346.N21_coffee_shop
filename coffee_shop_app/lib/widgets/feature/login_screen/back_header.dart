import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/blocs/auth_action/auth_action_cubit.dart';
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
            final AuthActionState current =
                context.read<AuthActionCubit>().state;
            if (current is ForgotPassword) {
              context.read<AuthActionCubit>().changeState(Login());
            } else {
              context.read<AuthActionCubit>().changeState(SignIn());
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
