import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'buttons/touchable_opacity.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox(
      {super.key,
      required this.value,
      this.onChanged,
      this.title,
      this.margin});
  final bool value;
  final Widget? title;
  final Function(bool?)? onChanged;
  final EdgeInsets? margin;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // color: Colors.green,
            margin: EdgeInsets.only(top: 3),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: widget.value,
                onChanged: (isChecked) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(isChecked);
                  }
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: TouchableOpacity(
              onTap: () {
                if (widget.onChanged != null) {
                  widget.onChanged!(!widget.value);
                }
              },
              child: widget.title ?? SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
