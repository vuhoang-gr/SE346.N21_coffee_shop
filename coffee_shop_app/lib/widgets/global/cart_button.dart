import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/functions/money_transfer.dart';
import '../../temp/data.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';

class CartButton extends StatefulWidget {
  final int amount;
  final double money;
  final ScrollController scrollController;
  const CartButton(
      {super.key,
      this.amount = 0,
      this.money = 0,
      required this.scrollController});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  int timeChange = 500;
  bool _isShowAll = true;

  ScrollController scrollController = ScrollController();
  int amount = 0;
  double money = 0;

  @override
  void initState() {
    super.initState();
    amount = widget.amount;
    money = widget.money;
    scrollController = widget.scrollController;
  }

  scrollListener() {
    if (scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        _isShowAll) {
      setState(() {
        _isShowAll = false;
      });
    } else if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        !_isShowAll) {
      setState(() {
        _isShowAll = true;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(scrollListener);

    return Positioned(
      bottom: Dimension.height8,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimension.width16, vertical: Dimension.height8),
        child: AnimatedContainer(
          duration: Duration(milliseconds: timeChange),
          height: _isShowAll ? Dimension.height56 : Dimension.height40,
          width: Dimension.width296,
          padding: EdgeInsets.symmetric(
              horizontal: Dimension.width8, vertical: Dimension.height8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: AppColors.greyIconColor,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: Offset(
                    0,
                    Dimension.height8, // Move to bottom 8.0 Vertically
                  ))
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: timeChange),
                      bottom: _isShowAll ? Dimension.height20 : 0,
                      top: 0,
                      left: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: timeChange),
                        height: _isShowAll
                            ? Dimension.height20
                            : Dimension.height32,
                        width: _isShowAll
                            ? Dimension.height20
                            : Dimension.height32,
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/delivery_small_icon.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: Dimension.height20,
                      left: Dimension.width24,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: timeChange),
                        opacity: _isShowAll ? 1 : 0,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Delivery to",
                            style: AppText.style.mediumGrey12,
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: timeChange),
                      bottom: 0,
                      left: _isShowAll ? 0 : Dimension.height32,
                      right: 0,
                      top: _isShowAll ? Dimension.height20 : 0,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Data.addresses[0].address.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.style.mediumBlack12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: Dimension.width8,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedPadding(
                  duration: Duration(milliseconds: timeChange),
                  padding: _isShowAll
                      ? EdgeInsets.symmetric(
                          horizontal: Dimension.width8,
                          vertical: Dimension.height6)
                      : EdgeInsets.symmetric(
                          horizontal: Dimension.width4,
                          vertical: Dimension.height4),
                  child: Row(
                    children: [
                      Container(
                        height: Dimension.height16,
                        width: Dimension.height16,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(Dimension.height8)),
                        child: Text(
                          amount.toString(),
                          style: AppText.style.mediumBlue12,
                        ),
                      ),
                      SizedBox(
                        width: Dimension.width4,
                      ),
                      Text(
                        "${MoneyTransfer.transferFromDouble(money)}đ",
                        style: AppText.style.mediumWhite12,
                      ),
                      SizedBox(
                        width: Dimension.width4,
                      ),
                      IconTheme(
                        data: IconThemeData(
                          size: Dimension.height10,
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: Dimension.width2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}