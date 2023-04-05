import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../utils/constants/dimension.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  var _index = 0;
  bool _isLiked = false;
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
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) => Center(
                      child: CachedNetworkImage(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        imageUrl:
                            'https://product.hstatic.net/1000075078/product/1675355354_bg-tch-sua-da-no_ffe5788190bb4639b594372a2794b11e_large.jpg',
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
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        '${_index + 1}/5',
                        style: TextStyle(
                            fontSize: Dimension.font14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
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
                              "Capuccino",
                              style: TextStyle(
                                  fontSize: Dimension.height16, height: 1.5),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "69.000 ₫",
                              style: TextStyle(
                                  fontSize: Dimension.font14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isLiked = !_isLiked;
                            });
                          },
                          icon: _isLiked
                              ? const Icon(
                                  CupertinoIcons.heart_fill,
                                  color: Colors.blue,
                                )
                              : const Icon(
                                  CupertinoIcons.heart,
                                  color: Color.fromRGBO(128, 128, 137, 1),
                                  weight: 10,
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimension.height8,
                    ),
                    Text(
                      "Dark, rich espresso lies in wait under a smoothed and stretched layer of thick milk foam. An alchemy of barista artistry and craft.",
                      style: TextStyle(
                          fontSize: Dimension.height12,
                          height: 1.5,
                          color: const Color.fromRGBO(128, 128, 137, 1)),
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
