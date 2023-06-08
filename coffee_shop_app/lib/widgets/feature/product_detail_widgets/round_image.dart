import 'package:coffee_shop_app/utils/constants/placeholder_enum.dart';
import 'package:flutter/material.dart';

import '../../global/aysncImage/async_image.dart';

class RoundImage extends StatelessWidget {
  const RoundImage({super.key, required this.imgUrl});
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: AsyncImage(
          src: imgUrl,
          type: PlaceholderType.food,
        ),
      ),
    );
  }
}
