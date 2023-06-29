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
                  src: product.food.images[0],
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
                    product.food.name,
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
                        product.size.name,
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
                      String topping = '';
                      if (product.toppings != null) {
                        for (var item in product.toppings!) {
                          topping += '${item.name}, ';
                        }
                      }
                      if (topping.length > 2) {
                        topping = topping.substring(0, topping.length - 2);
                      }
                      return Wrap(
                        children: [
                          Text(
                            'Topping: ',
                            style: AppText.style.mediumBlack14,
                          ),
                          Text(
                            topping,
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
