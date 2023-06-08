import 'package:coffee_shop_app/screens/customer_address/address_listing_screen.dart';
import 'package:coffee_shop_app/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/utils/validations/phone_validate.dart';
import 'package:coffee_shop_app/widgets/feature/profile_screen/change_password_dialog.dart';
import 'package:coffee_shop_app/widgets/feature/profile_screen/profile_custom_button.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:coffee_shop_app/widgets/global/custom_app_bar.dart';
import 'package:coffee_shop_app/widgets/global/textForm/custom_text_form.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../services/apis/auth_api.dart';
import '../../services/models/user.dart';
import '../../widgets/feature/profile_screen/image_dialog.dart';

class ProfileSettingScreen extends StatefulWidget {
  static const String routeName = '/profile_setting_screen';
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

// enum AuthState { login, signup, loggedIn }

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  User user = AuthAPI.currentUser!;

  bool isChangeInformation = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //change infor handle
    TextEditingController nameController =
        TextEditingController(text: user.name);
    TextEditingController dobController = TextEditingController(
        text:
            user.dob != null ? DateFormat('dd/MM/yyyy').format(user.dob!) : '');
    TextEditingController phoneController =
        TextEditingController(text: user.phoneNumber);
    onSaveInformation() {
      setState(() {
        isChangeInformation = false;
      });
      user.name = nameController.text;
      if (PhoneValidator().validate(phoneController.text)) {
        user.phoneNumber = phoneController.text;
      }
      try {
        user.dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      } catch (e) {
        print("user not choose any dob $e");
      } finally {
        setState(() {
          dobController = TextEditingController(
              text: user.dob != null
                  ? DateFormat('dd/MM/yyyy').format(user.dob!)
                  : '');
        });
        context.read<AuthBloc>().add(UserChanged(user: user));
      }
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Back button
                Navigator.of(context).canPop()
                    ? CustomAppBar()
                    : SizedBox(
                        height: Dimension.height32,
                      ),
                //body
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimension.getWidthFromValue(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Header
                        Text(
                          'Cài đặt',
                          style: AppText.style.boldBlack16.copyWith(
                            fontSize: Dimension.getWidthFromValue(34),
                          ),
                        ),
                        SizedBox(
                          height: Dimension.getHeightFromValue(15),
                        ),
                        //Body
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Personal Infomation
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Thông tin cá nhân',
                                  style: AppText.style.mediumBlack16.copyWith(
                                    fontSize: Dimension.getWidthFromValue(18),
                                  ),
                                ),
                                !isChangeInformation
                                    ? TouchableOpacity(
                                        onTap: () {
                                          if (context.mounted) {
                                            setState(() {
                                              isChangeInformation = true;
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Thay đổi',
                                          style: AppText.style.regularBlue16
                                              .copyWith(
                                            fontSize:
                                                Dimension.getWidthFromValue(14),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          TouchableOpacity(
                                            onTap: () {
                                              if (context.mounted) {
                                                setState(() {
                                                  isChangeInformation = false;
                                                  dobController =
                                                      TextEditingController(
                                                          text: user.dob != null
                                                              ? DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(
                                                                      user.dob!)
                                                              : '');
                                                });
                                              }
                                            },
                                            child: Text(
                                              'Hủy',
                                              style: AppText.style.regularGrey14
                                                  .copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                Dimension.getWidthFromValue(15),
                                          ),
                                          TouchableOpacity(
                                            onTap: onSaveInformation,
                                            child: Text(
                                              'Lưu',
                                              style: AppText.style.regularBlue16
                                                  .copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                            CustormTextForm(
                              margin: EdgeInsets.only(top: 30),
                              label: 'Họ và tên',
                              controller: nameController,
                              readOnly: !isChangeInformation,
                            ),
                            CustormTextForm(
                              margin: EdgeInsets.only(top: 30),
                              label: 'Ngày sinh',
                              controller: dobController,
                              readOnly: !isChangeInformation,
                              haveDatePicker: true,
                            ),
                            CustormTextForm(
                              margin: EdgeInsets.only(top: 30),
                              label: 'Số điện thoại',
                              controller: phoneController,
                              validator: PhoneValidator(),
                              readOnly: !isChangeInformation,
                            ),
                            SizedBox(
                              height: Dimension.getHeightFromValue(25),
                            ),
                            //Button
                            ProfileCustomButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(AddressListingScreen.routeName);
                              },
                              icon: Icons.home,
                              title: 'Địa chỉ giao hàng',
                              description: 'Thêm/sửa địa chỉ',
                            ),
                            SizedBox(
                              height: Dimension.getHeightFromValue(15),
                            ),
                            ProfileCustomButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return ChangePasswordDialog();
                                    }).then((value) {
                                  if (value as bool) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Password Changed!')));
                                  }
                                });
                              },
                              icon: Icons.security,
                              title: 'Mật khẩu',
                              description: 'Thay đổi mật khẩu',
                            ),
                          ],
                        ),
                        //Footer
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
