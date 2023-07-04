import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final Duration duration = const Duration(milliseconds: 269);
  final double opacity;
  final bool unable;

  const TouchableOpacity({
    super.key,
    required this.child,
    this.onTap,
    this.opacity = 0.5,
    this.unable = false,
  });

  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isDown = false;

  @override
  void initState() {
    super.initState();
    setState(() => isDown = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        if (!widget.unable) {
          isDown = true;
        }
      }),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      onTap: widget.unable ? null : widget.onTap,
      child: widget.unable
          ? Opacity(
              opacity: 0.6,
              child: widget.child,
            )
          : AnimatedOpacity(
              duration: widget.duration,
              opacity: isDown ? widget.opacity : 1,
              child: widget.child,
            ),
    );
  }
}
