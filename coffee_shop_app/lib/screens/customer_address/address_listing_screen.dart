import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_event.dart';
import 'package:coffee_shop_app/services/blocs/address_store/address_store_state.dart';
import 'package:coffee_shop_app/services/models/delivery_address.dart';
import 'package:coffee_shop_app/widgets/feature/address_screen/address_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/feature/address_screen/address_block_map.dart';
import '../../widgets/feature/address_screen/address_block_edit.dart';
import '../../widgets/global/custom_app_bar.dart';
import 'address_screen.dart';

class AddressListingScreen extends StatefulWidget {
  static const String routeName = "/address_listing_screen";
  const AddressListingScreen({super.key});

  @override
  State<AddressListingScreen> createState() => _AddressListingScreenState();
}

class _AddressListingScreenState extends State<AddressListingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              children: [
                CustomAppBar(
                  leading: Text(
                    "Giao hàng đến",
                    style: AppText.style.boldBlack18,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<AddressStoreBloc, AddressStoreState>(
                      builder: (context, state) {
                    if (state is LoadedState) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<AddressStoreBloc>(context)
                              .add(FetchData());
                        },
                        child: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimension.height16,
                                    vertical: Dimension.height16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const AddressBlock(),
                                    SizedBox(
                                      height: Dimension.height16,
                                    ),
                                    Text("Địa chỉ đã lưu",
                                        textAlign: TextAlign.left,
                                        style: AppText.style.boldBlack16),
                                    ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimension.height12),
                                        itemBuilder: (context, index) {
                                          return AddressBlockEdit(
                                            deliveryAddress: state
                                                .listDeliveryAddress[index],
                                            index: index,
                                          );
                                        },
                                        separatorBuilder: (_, __) => SizedBox(
                                            height: Dimension.height12),
                                        itemCount:
                                            state.listDeliveryAddress.length),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(AddressScreen.routeName,
                                                arguments: null)
                                            .then((value) {
                                          if (value != null &&
                                              value is DeliveryAddress) {
                                            BlocProvider.of<AddressStoreBloc>(
                                                    context)
                                                .add(Insert(
                                                    deliveryAddress: value));
                                          }
                                        });
                                      },
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              color: Colors.white),
                                          padding: EdgeInsets.symmetric(
                                              vertical: Dimension.height8,
                                              horizontal: Dimension.width16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: Dimension.height24,
                                                width: Dimension.height24,
                                                alignment: Alignment.center,
                                                child: IconTheme(
                                                    data: IconThemeData(
                                                      size: Dimension.height20,
                                                      color:
                                                          AppColors.blueColor,
                                                    ),
                                                    child: const Icon(
                                                      Icons.add,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: Dimension.width8,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                "Thêm địa chỉ mới",
                                                style:
                                                    AppText.style.boldBlack14,
                                              ))
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    } else if (state is LoadingState) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: Dimension.width16,
                            left: Dimension.width16,
                            top: Dimension.height16),
                        child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (_, __) {
                              return AddressSkeleton();
                            },
                            separatorBuilder: (_, __) {
                              return SizedBox(
                                height: Dimension.height12,
                              );
                            },
                            itemCount: 12),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ),
              ],
            )));
  }
}
