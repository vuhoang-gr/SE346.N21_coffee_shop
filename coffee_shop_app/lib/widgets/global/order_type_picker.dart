import 'package:coffee_shop_app/main.dart';
import 'package:coffee_shop_app/screens/store/store_selection_screen.dart';
import 'package:coffee_shop_app/services/blocs/cart_button/cart_button_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../services/blocs/cart_button/cart_button_state.dart';
import '../../services/models/store.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';

class OrderTypePicker extends StatelessWidget {
  const OrderTypePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      padding: EdgeInsets.symmetric(
        horizontal: Dimension.width16,
        vertical: Dimension.height16,
      ),
      child: BlocBuilder<CartButtonBloc, CartButtonState>(
          builder: (context, state) {
        return Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                BlocProvider.of<CartButtonBloc>(context).add(
                    ChangeSelectedOrderType(
                        selectedOrderType: OrderType.storePickup));
                if (state.selectedStore == null) {
                  Navigator.of(context)
                      .pushNamed(StoreSelectionScreen.routeName, arguments: {
                    "latLng": initLatLng,
                    "isPurposeForShowDetail": false
                  }).then((value) {
                    if (value != null && value is Store) {
                      BlocProvider.of<CartButtonBloc>(context)
                          .add(ChangeSelectedStore(selectedStore: value));
                      DefaultTabController.of(context).animateTo(1);
                    }
                  });
                } else {
                  DefaultTabController.of(context).animateTo(1);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Dimension.width108,
                    height: Dimension.height72,
                    child: Image.asset(
                      "assets/images/pickup_icon.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height8,
                  ),
                  Text(
                    "Mang đi",
                    style: AppText.style.mediumBlack16,
                  ),
                  Text(
                    "Chất lượng tốt nhất",
                    style: AppText.style.regularGrey14,
                  )
                ],
              ),
            )),
            SizedBox(
              width: Dimension.width16,
            ),
            Container(
              height: Dimension.height48,
              width: Dimension.width1,
              color: AppColors.greyBoxColor,
            ),
            SizedBox(
              width: Dimension.width16,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<CartButtonBloc>(context).add(
                      ChangeSelectedOrderType(
                          selectedOrderType: OrderType.delivery));
                  DefaultTabController.of(context).animateTo(1);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Dimension.width108,
                      height: Dimension.height72,
                      child: Image.asset(
                        "assets/images/delivery_icon.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: Dimension.height8,
                    ),
                    Text(
                      "Giao hàng",
                      style: AppText.style.mediumBlack16,
                    ),
                    Text(
                      "Luôn đúng giờ",
                      style: AppText.style.regularGrey14,
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
