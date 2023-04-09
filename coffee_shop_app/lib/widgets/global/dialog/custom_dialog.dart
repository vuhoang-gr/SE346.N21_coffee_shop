import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../utils/constants/dimension.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    super.key,
    this.child,
    required this.onChangeState,
  });

  final Widget? child;
  final VoidCallback onChangeState;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>
    with TickerProviderStateMixin {
  double maxHeight = Dimension.height / 1.5;

  late Animation<Offset> _slideAnimation;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    var keyboardController = KeyboardVisibilityController();
    keyboardController.onChange.listen((visible) {
      if (visible) {
        setState(() {
          maxHeight = Dimension.height / 2;
        });
      } else {
        setState(() {
          maxHeight = Dimension.height / 1.5;
        });
      }
    });

    _slideController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _slideController, curve: Curves.easeInOutCubic));

    //Set after widget is built
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _slideController.forward();
      _slideController.addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          widget.onChangeState();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _slideController.dispose();
  }

  @override
  Widget build(BuildContext acontext) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            _slideController.reverse();
          },
          child: SizedBox(
            child: Opacity(
              opacity: 0.35,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              // margin: EdgeInsets.only(top: 900),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(39),
                  topRight: Radius.circular(39),
                ),
              ),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 6) {
                        _slideController.reverse();
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 13),
                            width: Dimension.getWidthFromValue(60),
                            height: Dimension.getHeightFromValue(6),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimension.getWidthFromValue(16),
                    ),
                    child: Container(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        child: SingleChildScrollView(child: widget.child)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
