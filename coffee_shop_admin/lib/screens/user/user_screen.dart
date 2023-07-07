import 'package:coffee_shop_admin/services/apis/auth_api.dart';
import 'package:coffee_shop_admin/services/blocs/user/user_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/user/user_event.dart';
import 'package:coffee_shop_admin/services/blocs/user/user_state.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/feature/user/user_card.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:coffee_shop_admin/widgets/global/skeleton/list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScreen extends StatefulWidget {
  static const routeName = "/user_manage_screen";
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(FetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              leading: Text(
                'Users',
                style: AppText.style.boldBlack18,
              ),
            ),
            Expanded(child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is LoadedState) {
                return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<UserBloc>(context).add(FetchData());
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return UserCard(
                              self: state.users[index].email == AuthAPI.currentUser?.email,
                              user: state.users[index],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: Dimension.height12,
                            );
                          },
                          itemCount: state.users.length,
                        ),
                      ),
                    ));
              } else if (state is LoadingState) {
                return ListItemSkeleton();
              } else {
                print("err");
                return SizedBox.shrink();
              }
            })),
          ],
        ),
      ),
    );
  }
}
