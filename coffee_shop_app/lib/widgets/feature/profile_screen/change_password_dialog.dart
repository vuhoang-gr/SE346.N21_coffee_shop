import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';
import '../../../utils/validations/confirm_password_validate.dart';
import '../../../utils/validations/password_validate.dart';
import '../../global/buttons/rounded_button.dart';
import '../../global/dialog/swipe_up_dialog.dart';
import '../../global/textForm/custom_text_form.dart';

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
    bool canChangePassword() {
      if (PasswordValidator().validate(oldPassController.text) &&
          PasswordValidator().validate(newPassController.text) &&
          ConfirmPasswordValidator(oldPassword: newPassController)
              .validate(confirmPassController.text)) {
        return true;
      }
      return false;
    }

    onSubmit() async {
      if (!canChangePassword()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something is wrong. Try again!'),
          ),
        );
        return false;
      }
      var rawUser = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
          email: rawUser!.email!, password: oldPassController.text);
      try {
        await rawUser.reauthenticateWithCredential(credential);
        await rawUser.updatePassword(newPassController.text);
        return true;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password. Try again!'),
          ),
        );
        return false;
      }
    }

    return SwipeUpDialog(
      context: context,
      child: Column(
        children: [
          Text(
            "Thay đổi mật khẩu",
            style: AppText.style.mediumBlack16.copyWith(fontSize: 18),
          ),
          CustormTextForm(
            margin: EdgeInsets.symmetric(vertical: 20),
            controller: oldPassController,
            label: 'Mật khẩu cũ',
            secure: true,
            validator: PasswordValidator(),
          ),
          CustormTextForm(
            controller: newPassController,
            label: 'Mật khẩu mới',
            secure: true,
            validator: PasswordValidator(),
          ),
          CustormTextForm(
            margin: EdgeInsets.symmetric(vertical: 20),
            controller: confirmPassController,
            label: 'Nhập lại mật khẩu mới',
            secure: true,
            validator: ConfirmPasswordValidator(oldPassword: newPassController),
          ),
          RoundedButton(
            onPressed: () async {
              bool changed = await onSubmit();
              if (changed) {
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              }
            },
            height: Dimension.getHeightFromValue(40),
            label: 'LƯU MẬT KHẨU',
          ),
          SizedBox(
            height: Dimension.getHeightFromValue(15),
          )
        ],
      ),
    );
  }
}
