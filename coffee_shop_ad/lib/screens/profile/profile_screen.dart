import 'package:coffee_shop_admin/screens/profile/profile_setting_screen.dart';
import 'package:coffee_shop_admin/services/apis/auth_api.dart';
import 'package:coffee_shop_admin/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_admin/services/models/user.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/constants/placeholder_enum.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/global/aysncImage/async_image.dart';
import 'package:coffee_shop_admin/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/feature/profile_screen/profile_custom_button.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile_screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User user = AuthAPI.currentUser!;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: Dimension.getHeightFromValue(125),
                        child: AsyncImage(
                          src: user.coverUrl,
                        ),
                      ),
                      Container(
                        height: Dimension.getHeightFromValue(39),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TouchableOpacity(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Change cover')));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TouchableOpacity(
                        opacity: 0.8,
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 5),
                            borderRadius: BorderRadius.circular(72),
                          ),
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Color.fromARGB(255, 226, 226, 226),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: ClipOval(
                                child: AsyncImage(
                                  src: user.avatarUrl,
                                  type: PlaceholderType.user,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                user.name,
                style: AppText.style.boldBlack18,
              ),
              SizedBox(
                height: Dimension.getHeightFromValue(15),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimension.getWidthFromValue(16)),
                  child: Column(
                    children: [
                      ProfileCustomButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ProfileSettingScreen.routeName);
                        },
                        icon: Icons.settings,
                        title: 'Settings',
                        description: 'Profile, address, password',
                      ),
                      SizedBox(
                        height: Dimension.getHeightFromValue(15),
                      ),
                      ProfileCustomButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(LogOut());
                        },
                        icon: Icons.logout,
                        title: 'Sign out',
                        description: 'Go back to Login page',
                      ),
                      Expanded(child: SizedBox()),
                      TouchableOpacity(
                        child: Text(
                          'Term and Conditions',
                          style: AppText.style.regularBlue16.copyWith(
                              fontSize: 14,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(
                        height: Dimension.getHeightFromValue(12),
                      ),
                      Text(
                        'Version 1.0.0',
                        style: AppText.style.regularGrey12,
                      ),
                      SizedBox(
                        height: Dimension.getHeightFromValue(20),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
