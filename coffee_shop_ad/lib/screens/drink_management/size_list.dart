import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/drink_list/drink_list_event.dart';
import 'package:coffee_shop_admin/widgets/global/skeleton/list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/drink_list/drink_list_state.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import 'drink_item.dart';

class SizeList extends StatefulWidget {
  const SizeList({super.key});

  @override
  State<SizeList> createState() => _SizeListState();
}

class _SizeListState extends State<SizeList> {
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
              child: BlocBuilder<DrinkListBloc, DrinkListState>(
                  builder: (context, state) {
                if (state is LoadedState) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<DrinkListBloc>(context)
                              .add(FetchData());
                        },
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            SizedBox(height: Dimension.height8),
                            ...(state.listFood
                                .map((product) => Container(
                                      padding: EdgeInsets.only(
                                          bottom: Dimension.height8,
                                          left: Dimension.width16,
                                          right: Dimension.width16),
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
