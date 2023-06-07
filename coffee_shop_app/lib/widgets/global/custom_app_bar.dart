import 'package:flutter/material.dart';

import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {Key? key,
      this.leading,
      this.middle,
      this.trailing,
      this.color = Colors.white})
      : super(key: key);

  final Widget? middle;
  final Widget? leading;
  final Widget? trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimension.height56,
      width: double.infinity,
      color: color,
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Navigator.of(context).canPop()
                  ? IconButton(
                      icon: IconTheme(
                          data: IconThemeData(size: Dimension.height32),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: AppColors.blackColor,
                          )),
                      onPressed: () => Navigator.of(context).maybePop(),
                    )
                  : SizedBox(
                    width: Dimension.width16,
                  ),
              if (leading != null) leading!,
            ],
          ),
          SizedBox(
            width: Dimension.width8,
          ),
          Expanded(child: middle ?? SizedBox.shrink()),
          SizedBox(
            width: Dimension.width8,
          ),
          trailing ?? SizedBox(width: Dimension.width16,),
        ],
      ),
    );
  }
}
