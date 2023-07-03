import 'package:coffee_shop_staff/services/models/ordered_food.dart';
import 'package:coffee_shop_staff/utils/constants/placeholder_enum.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:coffee_shop_staff/widgets/global/aysncImage/async_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants/dimension.dart';

class OrderProductCard extends StatelessWidget {
  const OrderProductCard({
    super.key,
    required this.product,
  });
  final OrderedFood product;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimension.height8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              child: ClipOval(
                child: AsyncImage(
                  // src:
                  //     'https://product.hstatic.net/1000075078/product/cold-brew-sua-tuoi_379576_7fd130b7d162497a950503207876ef64.jpg',
                  src: product.image,
                  type: PlaceholderType.food,
                ),
              ),
            ),
            SizedBox(
              width: Dimension.height8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppText.style.boldBlack14.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Size: ',
                        style: AppText.style.mediumBlack14,
                      ),
                      Text(
                        product.size,
                        style: TextStyle(
                            fontSize: Dimension.height12,
                            color: Colors.black.withOpacity(0.8),
                            height: 1.5),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Unit price: ',
                        style: AppText.style.mediumBlack14,
                      ),
                      Text(
                        '${NumberFormat("#,##0.00", "en_US").format(product.unitPrice)} đ x ${product.amount}',
                        style: TextStyle(
                            fontSize: Dimension.height12,
                            color: Colors.black.withOpacity(0.8),
                            height: 1.5),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimension.height4,
                  ),
                  Builder(
                    builder: (context) {
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Topping: ',
                            style: AppText.style.mediumBlack14,
                          ),
                          Text(
                            product.topping != null &&
                                    product.topping!.isNotEmpty
                                ? product.topping!
                                : 'Không có',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
