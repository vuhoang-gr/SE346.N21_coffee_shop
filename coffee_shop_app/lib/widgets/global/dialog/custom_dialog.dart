import 'package:coffee_shop_app/utils/styles/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../utils/constants/dimension.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    super.key,
    this.child,
    this.header = "Header",
    this.headerAlignment = CrossAxisAlignment.center,
  });

  final Widget? child;
  final String header;
  final CrossAxisAlignment headerAlignment;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  double maxHeight = Dimension.height / 1.3;

  @override
  Widget build(BuildContext context) {
    var keyboardController = KeyboardVisibilityController();

    keyboardController.onChange.listen((visible) {
      if (context.mounted) {
        if (visible) {
          setState(() {
            maxHeight = Dimension.height / 2;
          });
        } else {
          setState(() {
            maxHeight = Dimension.height / 1.3;
          });
        }
      }
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: SizedBox(
                child: Opacity(
                  opacity: 1,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  // margin: EdgeInsets.only(top: 900),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        child: SingleChildScrollView(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimension.getWidthFromValue(14),
                                    vertical: Dimension.getWidthFromValue(10)),
                                child: Text(
                                  widget.header,
                                  style: AppText.style.regularBlack16.copyWith(
                                    fontSize: Dimension.getWidthFromValue(18),
                                  ),
                                ),
                              ),
                              widget.child!,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
