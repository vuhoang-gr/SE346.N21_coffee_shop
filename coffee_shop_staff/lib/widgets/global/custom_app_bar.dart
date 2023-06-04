import 'package:flutter/cupertino.dart';

import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, this.leading, this.middle, this.trailing, this.color = CupertinoColors.white})
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
              SizedBox(width: Dimension.width16),
              Navigator.of(context).canPop()
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 0, Dimension.width8, 0),
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: IconTheme(
                            data: IconThemeData(size: Dimension.height24),
                            child: const Icon(
                              CupertinoIcons.back,
                              color: AppColors.blackColor,
                            )),
                      ),
                    )
                  : Container(),
              if (leading != null) leading!,
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
