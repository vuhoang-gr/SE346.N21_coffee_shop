import 'package:coffee_shop_admin/screens/drink_management/topping_create.dart';
import 'package:coffee_shop_admin/screens/drink_management/topping_item.dart';
import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_event.dart';
import 'package:coffee_shop_admin/services/blocs/topping_list/topping_list_state.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/styles/button.dart';
import 'package:coffee_shop_admin/widgets/global/skeleton/list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';

class ToppingList extends StatefulWidget {
  const ToppingList({super.key});

  @override
  State<ToppingList> createState() => _ToppingListState();
}

class _ToppingListState extends State<ToppingList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ToppingListBloc>(context).add(FetchData());
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
              child: BlocBuilder<ToppingListBloc, ToppingListState>(
                  builder: (context, state) {
                if (state is LoadedState) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<ToppingListBloc>(context)
                              .add(FetchData());
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
                                      Navigator.of(context).pushNamed(
                                          CreateToppingScreen.routeName);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'New Topping',
                                          style: AppText.style.regularWhite16,
                                        )
                                      ],
                                    ))),
                            SizedBox(height: Dimension.height8),
                            ...(state.toppingList
                                .map((product) => Container(
                                      padding: EdgeInsets.only(
                                          bottom: Dimension.height8,
                                          left: Dimension.width16,
                                          right: Dimension.width16),
                                      child: (ToppingItem(
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
