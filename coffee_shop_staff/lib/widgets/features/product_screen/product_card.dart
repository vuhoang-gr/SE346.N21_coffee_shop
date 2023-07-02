import 'package:coffee_shop_staff/services/models/food_checker.dart';
import 'package:coffee_shop_staff/services/models/store_product.dart';
import 'package:coffee_shop_staff/services/models/topping.dart';
import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/constants/placeholder_enum.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:coffee_shop_staff/widgets/global/aysncImage/async_image.dart';
import 'package:coffee_shop_staff/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/models/food.dart';
import '../../../utils/constants/dimension.dart';

class ProductCard extends StatefulWidget {
  ProductCard(
      {super.key,
      required this.product,
      this.onPressed,
      required this.onDoFunction});
  final StoreProduct product;
  final void Function()? onPressed;
  final void Function() onDoFunction;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late StoreProduct product;

  late AnimationController swipeController;
  late Animation<Offset> swipeAnimation;
  late String imageUrl;
  late void Function()? onPressed;

  @override
  void initState() {
    super.initState();
    swipeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    swipeAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(-0.3, 0))
        .animate(
            CurvedAnimation(parent: swipeController, curve: Curves.linear));

    product = widget.product;
    onPressed = widget.onPressed;

    if (product.item is Food) {
      imageUrl = (product.item as Food).images[0];
    } else if (product.item is Topping) {
      imageUrl = (product.item as Topping).image;
    }
  }

  @override
  void dispose() {
    super.dispose();
    swipeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    product = widget.product;
    bool semiCheck = product is FoodChecker &&
        (product as FoodChecker).blockSize!.isNotEmpty &&
        product.isStocking;
    Color semiColor = semiCheck ? Colors.blueAccent : AppColors.greenColor;
    Color color = product.isStocking ? semiColor : AppColors.redColor;
    Color oppositeColor = color == semiColor ? AppColors.redColor : semiColor;
    return Stack(
      children: [
        SlideTransition(
          position: swipeAnimation,
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx < -5 &&
                  swipeController.status == AnimationStatus.dismissed) {
                swipeController.forward();
              } else if (details.delta.dx > 5 &&
                  swipeController.status == AnimationStatus.completed) {
                swipeController.reverse();
              }
            },
            onTap: () {
              if (onPressed != null) {
                onPressed!();
              } else {
                print('Product Card pressed');
              }
            },
            child: Container(
              // constraints: BoxConstraints(maxHeight: 200),
              // width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    child: ClipOval(
                      child: AsyncImage(
                        src: imageUrl,
                        type: PlaceholderType.food,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Dimension.width10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.item.name,
                          style: AppText.style.boldBlack16.copyWith(
                            color: color,
                          ),
                        ),
                        // Text(
                        //   product.item.id,
                        //   style: AppText.style.regularGrey14.copyWith(
                        //     color: Colors.black,
                        //   ),
                        // ),
                        Text(
                          '${NumberFormat("#,##0", "en_US").format(product.item.price)} đ',
                          style: AppText.style.regularGrey14.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TouchableOpacity(
                    opacity: 0.1,
                    onTap: () {
                      if (swipeController.status == AnimationStatus.completed) {
                        swipeController.reverse();
                      } else if (swipeController.status ==
                          AnimationStatus.dismissed) {
                        swipeController.forward();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.arrow_circle_left,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //fill all the stack for layoutBuilder contraints
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraint) {
              return AnimatedBuilder(
                animation: swipeController,
                builder: (context, child) {
                  //Positioned just work in stack
                  return Stack(
                    children: [
                      //Align widget to the right and take all the height
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        //width = maxWidth * remaining Screen * -1 (-1 is the direction)
                        width:
                            constraint.maxWidth * swipeAnimation.value.dx * -1,
                        child: TouchableOpacity(
                          onTap: () {
                            setState(() {
                              product.isStocking = !product.isStocking;
                            });
                            swipeController.reverse();
                            widget.onDoFunction();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: oppositeColor,
                            ),
                            child: Center(
                              child: Icon(
                                product.isStocking
                                    ? Icons.remove_shopping_cart
                                    : Icons.add_shopping_cart,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
