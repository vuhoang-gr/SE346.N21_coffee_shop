import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/models/store.dart';
import '../../../utils/constants/dimension.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoreDetailCard extends StatefulWidget {
  const StoreDetailCard({super.key, required this.store});
  final Store store;
  @override
  State<StoreDetailCard> createState() => _StoreDetailCardState();
}

class _StoreDetailCardState extends State<StoreDetailCard> {
  var _index = 0;
  bool _isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.only(
              left: Dimension.height16,
              right: Dimension.height16,
              top: Dimension.height12),
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
                            'https://images.edrawmind.com/article/swot-analysis-of-coffee-shop/1200_800.jpg',
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
                        style: AppText.style.regularWhite14,
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
                              widget.store.sb,
                              style: AppText.style.mediumBlack16,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "Open: 07:00 - 22:00",
                              style: AppText.style.regularBlack14,
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
