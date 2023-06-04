import 'package:coffee_shop_admin/services/models/size.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../services/functions/money_transfer.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';

class SizeCard extends StatefulWidget {
  const SizeCard({super.key, required this.product});
  final Size product;
  @override
  State<SizeCard> createState() => _SizeCardState();
}

class _SizeCardState extends State<SizeCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.only(
              left: Dimension.height16, right: Dimension.height16, top: 3),
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
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) => Center(
                      child: CachedNetworkImage(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        imageUrl: widget.product.image,
                        placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(),
                      ),
                    ),
                    onPageChanged: (page) {},
                  ),
                ),
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
                            Text(
                                "${MoneyTransfer.transferFromDouble(widget.product.price)} ₫",
                                style: AppText.style.boldBlack14),
                          ],
                        ),
                      ],
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
