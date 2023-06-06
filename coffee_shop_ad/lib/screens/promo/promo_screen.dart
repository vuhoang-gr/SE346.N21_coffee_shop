// import 'package:coffee_shop_app/screens/promo/promo_qr_scan.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_state.dart';
import 'package:coffee_shop_admin/services/blocs/promo/promo_event.dart';
import 'package:coffee_shop_admin/widgets/feature/promo_screen/promo_item.dart';
import 'package:coffee_shop_admin/widgets/feature/promo_screen/promo_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/models/promo.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/global/custom_app_bar.dart';

class PromoScreen extends StatefulWidget {
  static const String routeName = "/promo_screen";
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          CustomAppBar(
            leading: Text(
              "Promo",
              style: AppText.style.boldBlack18,
            ),
          ),
          Expanded(
            child:
                BlocBuilder<PromoBloc, PromoState>(builder: (context, state) {
              if (state is LoadedState) {
                return Column(
                  children: [
                    RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<PromoBloc>(context).add(FetchData());
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: Dimension.height8),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimension.width16),
                                child: ListView.separated(
                                  padding:
                                      EdgeInsets.only(top: Dimension.height8),
                                  itemCount: state.initPromos.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return PromoItem(
                                        promo: state.initPromos[index]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: Dimension.height12,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: Dimension.height8,
                              )
                            ],
                          ),
                        )),
                  ],
                );
              } else if (state is LoadingState) {
                return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimension.width16,
                        vertical: Dimension.height16),
                    child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, __) {
                          return PromoSkeleton();
                        },
                        separatorBuilder: (_, __) {
                          return SizedBox(
                            height: Dimension.height8,
                          );
                        },
                        itemCount: 10));
              } else {
                print("Some err in promo screen");
                return SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    ));
  }
}
