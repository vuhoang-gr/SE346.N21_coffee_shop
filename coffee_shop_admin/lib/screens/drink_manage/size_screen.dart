import 'package:coffee_shop_admin/screens/drink_manage/size_create.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_event.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_state.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/styles/button.dart';
import 'package:coffee_shop_admin/widgets/feature/drink_manage/size/size_item.dart';
import 'package:coffee_shop_admin/widgets/global/skeleton/list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SizeScreen extends StatefulWidget {
  const SizeScreen({super.key});

  @override
  State<SizeScreen> createState() => _SizeScreenState();
}

class _SizeScreenState extends State<SizeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SizeListBloc>(context).add(FetchData());
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
              child: BlocBuilder<SizeListBloc, SizeListState>(builder: (context, state) {
                if (state is LoadedState) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<SizeListBloc>(context).add(FetchData());
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
                                      Navigator.of(context).pushNamed(CreateSizeScreen.routeName);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'New Size',
                                          style: AppText.style.regularWhite16,
                                        )
                                      ],
                                    ))),
                            SizedBox(height: Dimension.height8),
                            ...(state.sizeList
                                .map((product) => Container(
                                      padding: EdgeInsets.only(
                                          bottom: Dimension.height8, left: Dimension.width16, right: Dimension.width16),
                                      child: (SizeItem(
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
