import 'package:coffee_shop_staff/utils/constants/dimension.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/images/img_splash_background.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(.8),
              ),
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
