import 'dart:io';

import 'package:coffee_shop_staff/utils/colors/app_colors.dart';
import 'package:coffee_shop_staff/utils/constants/dimension.dart';
import 'package:coffee_shop_staff/utils/constants/firestorage_bucket.dart';
import 'package:coffee_shop_staff/utils/styles/app_texts.dart';
import 'package:coffee_shop_staff/widgets/global/aysncImage/async_image.dart';
import 'package:coffee_shop_staff/widgets/global/buttons/rounded_button.dart';
import 'package:coffee_shop_staff/widgets/global/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/blocs/app_cubit/app_cubit.dart';

enum ImageStatus { view, edit }

class ImageViewScreen extends StatelessWidget {
  ImageViewScreen(
      {super.key,
      required this.image,
      this.imgStatus = ImageStatus.view,
      this.bucket,
      this.onSubmit});

  static const String routeName = '/image_view_screen';

  final String image;

  final ImageStatus imgStatus;

  final BUCKET? bucket;

  final storageRef = FirebaseStorage.instance.ref();

  final Function? onSubmit;

  @override
  Widget build(BuildContext context) {
    onSubmitImage() async {
      if (imgStatus == ImageStatus.view) {
        Navigator.pop(context);
        return null;
      }
      context.read<AppCubit>().changeState(AppLoading());

      File img = File(image);
      String fileName = img.path.split('/').last;
      final storageRef =
          FirebaseStorage.instance.ref().child(bucket!.getPath() + fileName);
      try {
        await storageRef.putFile(img);
        var url = await storageRef.getDownloadURL();
        if (onSubmit != null) {
          await onSubmit!(url);
        }
        // print(url);
        if (context.mounted) {
          context.read<AppCubit>().changeState(AppLoaded());
          Navigator.pop(context);
        }

        return url;
      } catch (e) {
        print('Image upload failed: $e');
        context.read<AppCubit>().changeState(AppLoaded());
        Navigator.pop(context);
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAppBar(
              color: Color.fromARGB(221, 71, 71, 71),
              middle: Text(
                'Xem ảnh',
                style: AppText.style.mediumWhite12
                    .copyWith(fontSize: Dimension.getWidthFromValue(20)),
              ),
            ),
            AsyncImage(src: image),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  imgStatus != ImageStatus.view
                      ? Expanded(
                          child: RoundedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: AppColors.backgroundColor,
                            child: Text(
                              'Hủy',
                              style: AppText.style.regularBlack16,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  imgStatus != ImageStatus.view
                      ? SizedBox(
                          width: Dimension.getWidthFromValue(20),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    child: RoundedButton(
                      onPressed: onSubmitImage,
                      backgroundColor: AppColors.backgroundColor,
                      child: Text(
                        'Xong',
                        style: AppText.style.regularBlack16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
