import 'dart:io';

import 'package:coffee_shop_app/utils/constants/placeholder_enum.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AsyncImage extends StatefulWidget {
  const AsyncImage({
    super.key,
    required this.src,
    this.placeholder,
    this.decoration,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.type = PlaceholderType.normal,
  });
  final String src;
  final String? placeholder;
  final DecorationImage? decoration;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final PlaceholderType type;

  @override
  State<AsyncImage> createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  // bool _loaded = false;
  // late var img;
  late Widget _placeholder;

  @override
  void initState() {
    super.initState();
    _placeholder = widget.placeholder != null
        ? Image.asset(
            widget.placeholder!,
            fit: BoxFit.cover,
          )
        : widget.type == PlaceholderType.normal
            ? Image.asset(
                'assets/images/placeholder/placeholder_normal.png',
                fit: BoxFit.cover,
              )
            : widget.type == PlaceholderType.user
                ? Image.asset(
                    'assets/images/placeholder/placeholder_user.jpg',
                    fit: BoxFit.cover,
                  )
                : widget.type == PlaceholderType.food
                    ? Image.asset(
                        'assets/images/placeholder/placeholder_food.jpg',
                        fit: BoxFit.cover,
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
  }

  @override
  Widget build(BuildContext context) {
    bool isLink = Uri.parse(widget.src).host.isNotEmpty || widget.src.isEmpty;

    return isLink
        ? CachedNetworkImage(
            width: widget.width,
            height: widget.height,
            imageUrl: widget.src,
            fit: widget.fit,
            placeholder: (context, url) {
              return Container(child: _placeholder);
            },
            errorWidget: (context, url, error) {
              return _placeholder;
            },
          )
        : Image.file(
            File(widget.src),
            fit: widget.fit,
          );
  }
}
