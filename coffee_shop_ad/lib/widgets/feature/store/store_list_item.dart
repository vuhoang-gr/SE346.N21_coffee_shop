import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../../services/blocs/cart_button/cart_button_bloc.dart';
// import '../../../services/blocs/cart_button/cart_button_state.dart';
import '../../../services/models/store.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../global/container_card.dart';

class StoreListItem extends StatelessWidget {
  final Store store;
  final VoidCallback tapHandler;
  const StoreListItem(
      {super.key, required this.store, required this.tapHandler});

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<CartButtonBloc, CartButtonState>(
    //     builder: (context, state) {
    return GestureDetector(
      onTap: tapHandler,
      child: ContainerCard(
          verticalPadding: Dimension.height8,
          horizontalPadding: Dimension.width16,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: Dimension.height32,
              width: Dimension.width32,
              child: IconTheme(
                data: IconThemeData(
                  size: Dimension.width32,
                  color: AppColors.blueColor,
                ),
                child: const FaIcon(FontAwesomeIcons.store),
              ),
            ),
            SizedBox(
              width: Dimension.width8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    store.sb,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.style.mediumBlack14.copyWith(height: 1),
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Text(
                    store.phone,
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: AppText.style.mediumGrey12,
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Text(
                    store.address.formattedAddress,
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: AppText.style.regularGrey12,
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  SizedBox.shrink(),
                ],
              ),
            ),
          ])),
    );
    //   });
  }
}
