import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../utils/constants/dimension.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.5),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                clipBehavior: Clip.hardEdge,
                margin:
                    EdgeInsets.only(bottom: Dimension.getHeightFromValue(50)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.9)),
                width: Dimension.width / 2,
                height: Dimension.width / 2,
                child: Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
