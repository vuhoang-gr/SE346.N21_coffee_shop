import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_app/utils/colors/app_colors.dart';
import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/utils/validations/email_validate.dart';
import 'package:coffee_shop_app/utils/validations/password_validate.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/blocs/auth_action/auth_action_cubit.dart';
import '../../widgets/feature/login_screen/information_dialog.dart';
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
  bool isRemember = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var isRmb = prefs.getBool('isRemember') ?? false;
    setState(() {
      isRemember = isRmb;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool canLogin() {
      if (EmailValidator().validate(emailController.text) &&
          PasswordValidator().validate(passwordController.text)) {
        return true;
      }
      return false;
    }

    onLogin() async {
      if (!canLogin()) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something is wrong! Try again!')));
        return;
      }
      var user = await AuthAPI()
          .emailLogin(emailController.text, passwordController.text);
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Something is wrong! Try again!')));
          return;
        }
      }

      if (context.mounted) {
        if (user!.name == "No Name") {
          var check = await showDialog(
              context: context, builder: (context) => InformationDialog());
          if (!check) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill the information!')));
              return;
            }
          }
        }
        if (context.mounted) {
          context.read<AuthBloc>().add(EmailLogin(
              email: emailController.text, password: passwordController.text));
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isRemember', isRemember);
        }
      }
    }

    var status = context.watch<AuthActionCubit>().state;
    if (status is Login) {
      if (status.email != null && status.email!.isNotEmpty) {
        emailController.text = status.email!;
      }
    }
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
          label: 'Mật khẩu',
          margin:
              EdgeInsets.symmetric(vertical: Dimension.getHeightFromValue(15)),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: Dimension.getHeightFromValue(39),
            top: Dimension.getHeightFromValue(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Checkbox(
                      value: isRemember,
                      onChanged: (isChecked) {
                        setState(() {
                          isRemember = !isRemember;
                        });
                      },
                    ),
                  ),
                  TouchableOpacity(
                    onTap: () {
                      setState(() {
                        isRemember = !isRemember;
                      });
                    },
                    child: Text(
                      'Ghi nhớ tôi',
                      style: AppText.style.regularBlack10.copyWith(
                        fontSize: Dimension.getWidthFromValue(15),
                      ),
                    ),
                  ),
                ],
              ),
              TouchableOpacity(
                onTap: () {
                  context
                      .read<AuthActionCubit>()
                      .changeState(ForgotPassword(email: emailController.text));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Quên mật khẩu?',
                      style: AppText.style.regularBlack10.copyWith(
                        fontSize: Dimension.getWidthFromValue(15),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Icon(
                        Icons.arrow_right_alt,
                        color: AppColors.blueColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        RoundedButton(
          onPressed: onLogin,
          label: "Đăng nhập",
        ),
      ],
    );
  }
}
