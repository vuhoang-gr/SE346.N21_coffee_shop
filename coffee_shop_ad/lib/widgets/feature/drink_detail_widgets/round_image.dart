import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoundImage extends StatelessWidget {
  const RoundImage({super.key, required this.imgUrl});
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: CachedNetworkImage(imageUrl: imgUrl),
      ),
    );
  }
}
