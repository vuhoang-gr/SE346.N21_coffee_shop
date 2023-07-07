import 'package:coffee_shop_staff/utils/constants/dimension.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:coffee_shop_staff/utils/validations/email_validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../services/apis/auth_api.dart';
import '../../services/blocs/app_cubit/app_cubit.dart';
import '../../services/blocs/auth_action/auth_action_cubit.dart';
import '../../widgets/global/buttons/rounded_button.dart';
import '../../widgets/global/textForm/custom_text_form.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.email});
  final String? email;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
  }

  bool canSubmit() {
    return EmailValidator().validate(emailController.text);
  }

  Future<void> onSubmit() async {
    if (!canSubmit()) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có gì đó không ổn. Hãy thử lại!')));
      return;
    }
    if (context.mounted) {
      context.read<AppCubit>().changeState(AppLoaded());

      context.read<AppCubit>().changeState(AppLoading());
    }
    var check = await AuthAPI().forgotPassword(emailController.text);

    if (context.mounted) {
      await QuickAlert.show(
          context: context,
          type: !check ? QuickAlertType.error : QuickAlertType.success,
          title: !check ? 'Oops' : 'Success',
          text: !check
              ? 'Tài khoản này chưa được đăng ký. Hãy đăng ký trước đó.'
              : 'Chúng tôi đã gửi cho bạn một email để đặt lại mật khẩu, hãy kiểm tra email của mình.',
          confirmBtnText: !check ? 'OK' : 'Quay lại đăng nhập',
          barrierDismissible: false,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            if (check) {
              context
                  .read<AuthActionCubit>()
                  .changeState(Login(email: emailController.text));
            }
          });
    }
    if (context.mounted) {
      context.read<AppCubit>().changeState(AppLoaded());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Vui lòng nhập email phía bên dưới, chúng tôi sẽ gửi cho bạn một hướng dẫn đổi mật khẩu mới thông qua email!',
          style: AppText.style.regularBlack10.copyWith(
            fontSize: Dimension.getWidthFromValue(15),
          ),
        ),
        CustormTextForm(
          margin: EdgeInsets.only(top: 30),
          controller: emailController,
          validator: EmailValidator(),
          verifiedCheck: true,
          label: 'Email',
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: Dimension.getHeightFromValue(39),
            top: Dimension.getHeightFromValue(9),
          ),
        ),
        RoundedButton(
          onPressed: onSubmit,
          label: "GỬI",
        ),
      ],
    );
  }
}
