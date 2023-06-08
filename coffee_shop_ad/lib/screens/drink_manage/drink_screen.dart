import 'package:coffee_shop_admin/screens/drink_manage/drink_create.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_event.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/styles/button.dart';
import 'package:coffee_shop_admin/widgets/global/skeleton/list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/drink_list/drink_list_state.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import 'drink_item.dart';

class DrinkScreen extends StatefulWidget {
  const DrinkScreen({super.key});

  @override
  State<DrinkScreen> createState() => _DrinkListState();
}

class _DrinkListState extends State<DrinkScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DrinkListBloc>(context).add(FetchData());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: BlocBuilder<DrinkListBloc, DrinkListState>(builder: (context, state) {
                if (state is LoadedState) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<DrinkListBloc>(context).add(FetchData());
                        },
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            SizedBox(height: Dimension.height8),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimension.width16,
                                ),
                                child: ElevatedButton(
                                    style: roundedButton,
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(CreateDrinkScreen.routeName).then((value) {
                                        BlocProvider.of<DrinkListBloc>(context).add(FetchData());
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'New Drink',
                                          style: AppText.style.regularWhite16,
                                        )
                                      ],
                                    ))),
                            SizedBox(height: Dimension.height8),
                            ...(state.listFood
                                .map((product) => Container(
                                      padding: EdgeInsets.only(
                                          bottom: Dimension.height8, left: Dimension.width16, right: Dimension.width16),
                                      child: (DrinkItem(
                                        product: product,
                                      )),
                                    ))
                                .toList()),
                            SizedBox(
                              height: Dimension.height68,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is LoadingState) {
                  return ListItemSkeleton();
                } else {
                  return SizedBox.shrink();
                }
              }),
            ),
          ),
        ],
      ),
    ));
  }
}
