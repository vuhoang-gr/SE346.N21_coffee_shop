import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/apis/auth_api.dart';
import '../../../services/models/user.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';
import '../../../utils/validations/phone_validate.dart';
import '../../global/buttons/rounded_button.dart';
import '../../global/dialog/swipe_up_dialog.dart';
import '../../global/textForm/custom_text_form.dart';

class InformationDialog extends StatefulWidget {
  const InformationDialog({super.key, required this.user});
  final User? user;

  @override
  State<InformationDialog> createState() => _InformationDialogState();
}

class _InformationDialogState extends State<InformationDialog> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController dobController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.user!.name;
  }

  @override
  Widget build(BuildContext context) {
    bool canSaveInfor() {
      if (nameController.text.length > 1 &&
          dobController.text.isNotEmpty &&
          PhoneValidator().validate(phoneController.text)) {
        return true;
      }
      return false;
    }

    onSubmit() async {
      User? temp = widget.user;

      if (!canSaveInfor() || temp == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có gì đó không ổn. Hãy thử lại!'),
          ),
        );
        return false;
      }
      temp.name = nameController.text;
      temp.dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      temp.phoneNumber = phoneController.text;

      try {
        await AuthAPI().update(temp);
        return true;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật thất bại. Hãy thử lại!'),
          ),
        );
        return false;
      } finally {
        // await AuthAPI().signOut();
      }
    }

    return SwipeUpDialog(
      context: context,
      child: Column(
        children: [
          Text(
            "Thông tin cá nhân",
            style: AppText.style.mediumBlack16
                .copyWith(fontSize: Dimension.getFontSize(18)),
          ),
          CustormTextForm(
            margin: EdgeInsets.symmetric(
                vertical: Dimension.getHeightFromValue(20)),
            controller: nameController,
            label: 'Họ và tên',
          ),
          CustormTextForm(
            controller: dobController,
            label: 'Ngày sinh',
            haveDatePicker: true,
          ),
          CustormTextForm(
            margin: EdgeInsets.symmetric(
                vertical: Dimension.getHeightFromValue(20)),
            controller: phoneController,
            label: 'Số điện thoại',
            validator: PhoneValidator(),
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
            label: 'KHÁM PHÁ NGAY',
          ),
          SizedBox(
            height: Dimension.getHeightFromValue(15),
          )
        ],
      ),
    );
  }
}
