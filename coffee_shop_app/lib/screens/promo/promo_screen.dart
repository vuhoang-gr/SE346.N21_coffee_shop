import 'package:coffee_shop_app/screens/promo/promo_qr_scan.dart';
import 'package:coffee_shop_app/services/apis/promo_api.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/promo_store/promo_store_state.dart';
import 'package:coffee_shop_app/widgets/feature/promo_screen/promo_item.dart';
import 'package:coffee_shop_app/widgets/feature/promo_screen/promo_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/blocs/promo_store/promo_store_event.dart';
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
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
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
              "Mã khuyến mãi",
              style: AppText.style.boldBlack18,
            ),
          ),
          Expanded(
            child: BlocBuilder<PromoStoreBloc, PromoStoreState>(
                builder: (context, state) {
              if (state is LoadedState) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: Dimension.height16,
                          bottom: Dimension.height16,
                          right: Dimension.width4),
                      color: Colors.white,
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              onSubmitted: (value) {
                                _usePromo();
                              },
                              style: AppText.style.regularBlack14,
                              decoration: InputDecoration(
                                  prefixIcon: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(PromoQRScan.routeName)
                                            .then((value) {
                                          if (value != null) {
                                            controller.text = value.toString();
                                          }
                                        });
                                      },
                                      child: const Icon(CupertinoIcons.qrcode)),
                                  contentPadding: EdgeInsets.only(
                                      top: Dimension.height8,
                                      left: Dimension.height16,
                                      right: Dimension.height16),
                                  hintText: 'Nhập mã khuyến mãi',
                                  hintStyle: AppText.style.regularGrey14,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                          color: Colors.black)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                          color: AppColors.greyTextField))),
                            ),
                          ),
                          SizedBox(
                            width: Dimension.width8,
                          ),
                          TextButton(
                              onPressed: () {
                                _usePromo();
                              },
                              child: Text(
                                "Áp dụng",
                                style: AppText.style.regularBlue14,
                              ))
                        ],
                      ),
                    ),
                    RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<PromoStoreBloc>(context)
                              .add(FetchData());
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
                                  itemCount: PromoAPI().currentPromos.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return PromoItem(
                                        promo: PromoAPI().currentPromos[index]);
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
                return SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    ));
  }

  void _usePromo() {
    List<Promo> promos = PromoAPI().currentPromos;
    for (Promo promo in promos) {
      if (promo.id == controller.text) {
        Navigator.of(context).pop(promo);
        return;
      }
    }
    Fluttertoast.showToast(
          msg: "Mã khuyến mãi không tồn tại hoặc quá hạn sử dụng.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: Dimension.font14);
  }
}
