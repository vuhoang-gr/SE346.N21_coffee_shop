import 'package:coffee_shop_admin/services/apis/auth_api.dart';
import 'package:coffee_shop_admin/services/models/user.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/feature/profile_screen/change_password_dialog.dart';
import 'package:coffee_shop_admin/widgets/feature/profile_screen/profile_custom_button.dart';
import 'package:coffee_shop_admin/widgets/global/buttons/touchable_opacity.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:coffee_shop_admin/widgets/global/textForm/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  Widget build(BuildContext context) {
    //change infor handle
    TextEditingController nameController = TextEditingController(text: user.name);
    TextEditingController dobController =
        TextEditingController(text: user.dob != null ? DateFormat('dd/MM/yyyy').format(user.dob!) : '');

    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
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
                          'Settings',
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
                                  'Personal Information',
                                  style: AppText.style.mediumBlack16.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                !isChangeInformation
                                    ? TouchableOpacity(
                                        onTap: () {
                                          setState(() {
                                            isChangeInformation = true;
                                          });
                                        },
                                        child: Text(
                                          'Change',
                                          style: AppText.style.regularBlue16.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          TouchableOpacity(
                                            onTap: () {
                                              setState(() {
                                                isChangeInformation = false;
                                                dobController = TextEditingController(
                                                    text: user.dob != null
                                                        ? DateFormat('dd/MM/yyyy').format(user.dob!)
                                                        : '');
                                              });
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: AppText.style.regularGrey14.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimension.getWidthFromValue(15),
                                          ),
                                          TouchableOpacity(
                                            onTap: () {
                                              setState(() {
                                                isChangeInformation = false;
                                              });
                                              user.name = nameController.text;
                                              try {
                                                user.dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
                                              } finally {
                                                setState(() {
                                                  dobController = TextEditingController(
                                                      text: user.dob != null
                                                          ? DateFormat('dd/MM/yyyy').format(user.dob!)
                                                          : '');
                                                });
                                              }
                                            },
                                            child: Text(
                                              'Save',
                                              style: AppText.style.regularBlue16.copyWith(
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
                              label: 'Fullname',
                              controller: nameController,
                              readOnly: !isChangeInformation,
                            ),
                            CustormTextForm(
                              margin: EdgeInsets.only(top: 30),
                              label: 'Date of birth',
                              controller: dobController,
                              readOnly: !isChangeInformation,
                              haveDatePicker: true,
                            ),
                            SizedBox(
                              height: Dimension.getHeightFromValue(25),
                            ),
                            //Button
                            ProfileCustomButton(
                              onPressed: () {
                                showGeneralDialog(
                                    context: context,
                                    pageBuilder: (_, __, ___) {
                                      return ChangePasswordDialog();
                                    });
                              },
                              icon: Icons.security,
                              title: 'Password',
                              description: 'Change password',
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
