import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final Duration duration = const Duration(milliseconds: 169);
  final double opacity = 0.5;

  const TouchableOpacity({super.key, required this.child, this.onTap});

  @override
  _TouchableOpacityState createState() => _TouchableOpacityState();
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
      onTapDown: (_) => setState(() => isDown = true),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: isDown ? widget.opacity : 1,
        child: widget.child,
      ),
    );
  }
}
