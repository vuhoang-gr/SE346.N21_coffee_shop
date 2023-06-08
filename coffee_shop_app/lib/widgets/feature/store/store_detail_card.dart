import 'package:coffee_shop_app/services/blocs/store_store/store_store_bloc.dart';
import 'package:coffee_shop_app/services/blocs/store_store/store_store_event.dart';
import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../services/blocs/store_store/store_store_state.dart';
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
                    itemCount: widget.store.images.length,
                    itemBuilder: (BuildContext context, int index) => Center(
                      child: CachedNetworkImage(
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        imageUrl: widget.store.images[index],
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
                        '${_index + 1}/${widget.store.images.length}',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.store.sb,
                                softWrap: true,
                                style: AppText.style.mediumBlack16,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Open: ${DateFormat('hh:mm').format(widget.store.timeOpen)} - ${DateFormat('hh:mm').format(widget.store.timeClose)}",
                                style: AppText.style.regularBlack14,
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<StoreStoreBloc, StoreStoreState>(
                          builder: (context, state) {
                            return IconButton(
                              onPressed: () {
                                BlocProvider.of<StoreStoreBloc>(context)
                                    .add(UpdateFavorite(store: widget.store));
                              },
                              icon: widget.store.isFavorite
                                  ? const Icon(
                                      CupertinoIcons.heart_fill,
                                      color: Colors.blue,
                                    )
                                  : const Icon(
                                      CupertinoIcons.heart,
                                      color: Color.fromRGBO(128, 128, 137, 1),
                                      weight: 10,
                                    ),
                            );
                          },
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
