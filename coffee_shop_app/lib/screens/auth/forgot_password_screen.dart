import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/utils/validations/email_validate.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimension.getHeightFromValue(72),
        ),
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
          onPressed: () {},
          label: "GỬI",
        ),
      ],
    );
  }
}
