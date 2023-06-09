import 'package:coffee_shop_admin/services/functions/money_transfer.dart';
import 'package:coffee_shop_admin/services/models/drink.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});
  final Drink product;
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.only(left: Dimension.height16, right: Dimension.height16, top: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(children: [
                // pageView product image
                AspectRatio(
                  aspectRatio: 1,
                  child: PageView.builder(
                    itemCount: widget.product.images.length,
                    itemBuilder: (BuildContext context, int index) => Center(
                      child: CachedNetworkImage(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        imageUrl: widget.product.images[index],
                        placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(),
                      ),
                    ),
                    onPageChanged: (page) {
                      setState(() {
                        _index = page;
                      });
                    },
                  ),
                ),
                Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: Dimension.height8,
                          bottom: Dimension.height8,
                          left: Dimension.height12,
                          right: Dimension.height12),
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(16)),
                      child: Text('${_index + 1}/${widget.product.images.length}', style: AppText.style.regularWhite14),
                    ))
              ]),

              //product information
              Padding(
                padding: EdgeInsets.only(
                    left: Dimension.height16,
                    right: Dimension.height16,
                    top: Dimension.height12,
                    bottom: Dimension.height16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: AppText.style.regularBlack16,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text("${MoneyTransfer.transferFromDouble(widget.product.price)} ₫",
                                style: AppText.style.boldBlack14),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimension.height8,
                    ),
                    Text(
                      widget.product.description,
                      style: AppText.style.regularGrey12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
