import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/validations/confirm_password_validate.dart';
import 'package:coffee_shop_admin/utils/validations/password_validate.dart';
import 'package:coffee_shop_admin/widgets/global/buttons/rounded_button.dart';
import 'package:coffee_shop_admin/widgets/global/dialog/swipe_up_dialog.dart';
import 'package:coffee_shop_admin/widgets/global/textForm/custom_text_form.dart';
import 'package:flutter/widgets.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SwipeUpDialog(
      child: Column(
        children: [
          Text(
            "Password Change",
            style: AppText.style.mediumBlack16.copyWith(fontSize: 18),
          ),
          CustormTextForm(
            margin: EdgeInsets.symmetric(vertical: 20),
            controller: oldPassController,
            label: 'Old Password',
            secure: true,
            validator: PasswordValidator(),
          ),
          CustormTextForm(
            controller: newPassController,
            label: 'New Password',
            secure: true,
            validator: PasswordValidator(),
          ),
          CustormTextForm(
            margin: EdgeInsets.symmetric(vertical: 20),
            controller: confirmPassController,
            label: 'Confirm New Password',
            secure: true,
            validator: ConfirmPasswordValidator(oldPassword: newPassController),
          ),
          RoundedButton(
            onPressed: () {},
            height: Dimension.getHeightFromValue(40),
            label: 'SAVE PASSWORD',
          ),
          SizedBox(
            height: Dimension.getHeightFromValue(15),
          )
        ],
      ),
    );
  }
}
