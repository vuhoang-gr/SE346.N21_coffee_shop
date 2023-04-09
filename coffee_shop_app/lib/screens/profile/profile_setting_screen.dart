import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/utils/validations/confirm_password_validate.dart';
import 'package:coffee_shop_app/utils/validations/password_validate.dart';
import 'package:coffee_shop_app/widgets/feature/login_screen/back_header.dart';
import 'package:coffee_shop_app/widgets/feature/profile_screen/profile_custom_button.dart';
import 'package:coffee_shop_app/widgets/global/buttons/rounded_button.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:coffee_shop_app/widgets/global/textForm/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/models/user.dart';
import '../../widgets/global/dialog/custom_dialog.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

// enum AuthState { login, signup, loggedIn }

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  User userTest = User(
      id: '1',
      name: 'Yau Boii',
      phoneNumber: '0101010101',
      email: 'fuck@gm.co',
      isActive: true,
      dob: DateTime(2003, 6, 11));
  bool isPassWordDialogOpen = false;
  bool isChangeInformation = false;

  @override
  Widget build(BuildContext context) {
    //change password handle
    TextEditingController oldPassController = TextEditingController();
    TextEditingController newPassController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();
    //change infor handle
    TextEditingController nameController =
        TextEditingController(text: userTest.name);
    TextEditingController dobController = TextEditingController(
        text: userTest.dob != null
            ? DateFormat('dd/MM/yyyy').format(userTest.dob!)
            : '');
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
                    ? BackHeader()
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
                                          style: AppText.style.regularBlue16
                                              .copyWith(
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
                                                dobController =
                                                    TextEditingController(
                                                        text: userTest.dob !=
                                                                null
                                                            ? DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(userTest
                                                                    .dob!)
                                                            : '');
                                              });
                                            },
                                            child: Text(
                                              'Cancel',
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
                                            onTap: () {
                                              setState(() {
                                                isChangeInformation = false;
                                              });
                                              userTest.name =
                                                  nameController.text;
                                              try {
                                                userTest.dob = DateFormat(
                                                        'dd/MM/yyyy')
                                                    .parse(dobController.text);
                                              } finally {
                                                setState(() {
                                                  dobController =
                                                      TextEditingController(
                                                          text: userTest.dob !=
                                                                  null
                                                              ? DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(
                                                                      userTest
                                                                          .dob!)
                                                              : '');
                                                });
                                              }
                                            },
                                            child: Text(
                                              'Save',
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Nav to AddressListingScreen')));
                              },
                              icon: Icons.home,
                              title: 'Shipping address',
                              description: 'Add/change address',
                            ),
                            SizedBox(
                              height: Dimension.getHeightFromValue(15),
                            ),
                            ProfileCustomButton(
                              onPressed: () {
                                setState(() {
                                  isPassWordDialogOpen = true;
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
            isPassWordDialogOpen
                ? CustomDialog(
                    onChangeState: () {
                      setState(() {
                        isPassWordDialogOpen = !isPassWordDialogOpen;
                      });
                    },
                    // isOpen: isPassWordDialogOpen,
                    child: Column(
                      children: [
                        Text(
                          "Password Change",
                          style: AppText.style.mediumBlack16
                              .copyWith(fontSize: 18),
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
                          validator: ConfirmPasswordValidator(
                              oldPassword: newPassController),
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
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
