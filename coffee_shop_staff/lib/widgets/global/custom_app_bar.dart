import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {Key? key,
      this.leading,
      this.middle,
      this.trailing,
      this.color = CupertinoColors.white})
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
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: color != Color.fromARGB(221, 71, 71, 71)
                                ? AppColors.blackColor
                                : Colors.white,
                          )),
                      onPressed: () => Navigator.of(context).maybePop(),
                    )
                  : SizedBox(
                      width: Dimension.width16,
                    ),
              if (leading != null)
                Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  child: leading!,
                ),
            ],
          ),
          SizedBox(
            width: Dimension.width8,
          ),
          Expanded(child: middle ?? Container()),
          SizedBox(
            width: Dimension.width8,
          ),
          trailing ?? Container(),
          SizedBox(width: Dimension.width16),
        ],
      ),
    );
  }
}
