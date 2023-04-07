import 'package:coffee_shop_app/services/blocs/auth_cubit/auth_cubit.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/utils/validations/email_validate.dart';
import 'package:coffee_shop_app/utils/validations/password_validate.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/global/buttons/rounded_button.dart';
import '../../widgets/global/textForm/custom_text_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimension.getHeightFromValue(72),
        ),
        CustormTextForm(
          controller: emailController,
          validator: EmailValidator(),
          verifiedCheck: true,
          label: 'Email',
        ),
        CustormTextForm(
          controller: passwordController,
          validator: PasswordValidator(),
          verifiedCheck: true,
          secure: true,
          label: 'Password',
          margin:
              EdgeInsets.symmetric(vertical: Dimension.getHeightFromValue(15)),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: Dimension.getHeightFromValue(39),
            top: Dimension.getHeightFromValue(9),
          ),
          child: TouchableOpacity(
            onTap: () {
              context
                  .read<AuthCubit>()
                  .changeState(ForgotPassword(email: emailController.text));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Forgot your password?',
                  style: AppText.style.regularBlack10.copyWith(
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.arrow_right_alt,
                  color: AppColors.blueColor,
                )
              ],
            ),
          ),
        ),
        RoundedButton(
          onPressed: () {},
          label: "LOGIN",
        ),
      ],
    );
  }
}
