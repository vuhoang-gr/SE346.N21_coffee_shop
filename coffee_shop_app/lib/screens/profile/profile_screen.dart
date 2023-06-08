import 'package:coffee_shop_app/screens/profile/profile_setting_screen.dart';
import 'package:coffee_shop_app/services/apis/auth_api.dart';
import 'package:coffee_shop_app/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_app/services/models/user.dart';
import 'package:coffee_shop_app/utils/constants/dimension.dart';
import 'package:coffee_shop_app/utils/constants/image_enum.dart';
import 'package:coffee_shop_app/utils/constants/placeholder_enum.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:coffee_shop_app/widgets/feature/profile_screen/change_password_dialog.dart';
import 'package:coffee_shop_app/widgets/feature/profile_screen/image_dialog.dart';
import 'package:coffee_shop_app/widgets/global/aysncImage/async_image.dart';
import 'package:coffee_shop_app/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/feature/profile_screen/profile_custom_button.dart';
import '../../widgets/global/buttons/rounded_button.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile_screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User user = AuthAPI.currentUser!;
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                      height: Dimension.getHeightFromValue(42),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TouchableOpacity(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => ImageDialog(
                                imageType: ImageType.cover,
                                source: user.coverUrl,
                              ));
                      setState(() {});
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
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return ImageDialog(source: user.avatarUrl);
                            });
                        setState(() {});
                      },
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          borderRadius: BorderRadius.circular(
                              Dimension.getWidthFromValue(47.5)),
                        ),
                        width: Dimension.getWidthFromValue(95),
                        height: Dimension.getWidthFromValue(95),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                Dimension.getWidthFromValue(45)),
                          ),
                          height: Dimension.getWidthFromValue(90),
                          width: Dimension.getWidthFromValue(90),
                          child: ClipRRect(
                            child: AsyncImage(
                              fit: BoxFit.cover,
                              src: user.avatarUrl,
                              type: PlaceholderType.user,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                print(state);
                return Text(
                  (state as Authenticated).user.name,
                  style: AppText.style.boldBlack18,
                );
              },
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
                        DefaultTabController.of(context).animateTo(3);
                      },
                      icon: Icons.shopping_cart,
                      title: 'Đơn hàng của tôi',
                      description: 'Lịch sử/trạng thái đơn hàng',
                    ),
                    SizedBox(
                      height: Dimension.getHeightFromValue(15),
                    ),
                    ProfileCustomButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Show dialog')));
                      },
                      icon: Icons.support_agent,
                      title: 'Hỗ trợ',
                      description: 'Liên hệ với chúng tôi',
                    ),
                    SizedBox(
                      height: Dimension.getHeightFromValue(15),
                    ),
                    ProfileCustomButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ProfileSettingScreen.routeName);
                      },
                      icon: Icons.settings,
                      title: 'Cài đặt',
                      description: 'Cá nhân, Địa chỉ, Mật khẩu',
                    ),
                    SizedBox(
                      height: Dimension.getHeightFromValue(15),
                    ),
                    ProfileCustomButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogOut());
                      },
                      icon: Icons.logout,
                      title: 'Đăng xuất',
                      description: 'Về lại trang đăng nhập',
                      haveArrow: false,
                    ),
                    Expanded(child: SizedBox()),
                    TouchableOpacity(
                      child: Text(
                        'Điều khoản và điều kiện',
                        style: AppText.style.regularBlue16.copyWith(
                            fontSize: 14, decoration: TextDecoration.underline),
                      ),
                    ),
                    SizedBox(
                      height: Dimension.getHeightFromValue(12),
                    ),
                    Text(
                      'Phiên bản 1.0.0',
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
    );
  }
}
