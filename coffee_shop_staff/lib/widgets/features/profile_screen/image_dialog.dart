import 'package:coffee_shop_staff/screens/profile/image_view_screen.dart';
import 'package:coffee_shop_staff/services/apis/auth_api.dart';
import 'package:coffee_shop_staff/services/blocs/auth/auth_bloc.dart';
import 'package:coffee_shop_staff/utils/constants/firestorage_bucket.dart';
import 'package:coffee_shop_staff/utils/constants/image_enum.dart';
import 'package:coffee_shop_staff/widgets/global/buttons/touchable_opacity.dart';
import 'package:coffee_shop_staff/widgets/global/dialog/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/models/user.dart';
import '../../../utils/styles/app_texts.dart';

// ignore: must_be_immutable
class ImageDialog extends StatelessWidget {
  ImageDialog(
      {super.key, this.imageType = ImageType.avatar, required this.source});

  ImageType imageType;
  final ImagePicker imagePicker = ImagePicker();
  final String source;

  @override
  Widget build(BuildContext context) {
    onSubmit(String url) async {
      User temp = AuthAPI.currentUser!;
      switch (imageType) {
        case ImageType.avatar:
          temp.avatarUrl = url;
          context.read<AuthBloc>().add(UserChanged(user: temp));
          break;
        case ImageType.cover:
          temp.coverUrl = url;
          context.read<AuthBloc>().add(UserChanged(user: temp));
          break;
        default:
          break;
      }
    }

    onPickImage() async {
      try {
        var pickedFile =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          print(pickedFile.path);
        } else {
          print('No image is selected');
          return;
        }
        BUCKET bucket;
        var rawBucket = FireStorageBUCKET(id: AuthAPI.currentUser!.id);
        switch (imageType) {
          case ImageType.avatar:
            bucket = rawBucket.user.avatar;
            break;
          case ImageType.cover:
            bucket = rawBucket.user.cover;
            break;
          default:
            bucket = rawBucket.image;
            break;
        }
        if (context.mounted) {
          await Navigator.of(context).pushNamed(ImageViewScreen.routeName,
              arguments: {pickedFile.path, ImageStatus.edit, bucket, onSubmit});
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        print('Image pick error: $e');
      }
    }

    return CustomDialog(
      header: 'Chọn ảnh',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TouchableOpacity(
            onTap: () async {
              await Navigator.of(context).pushNamed(ImageViewScreen.routeName,
                  arguments: {source, ImageStatus.view});
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              alignment: Alignment.centerLeft,
              child: Text(
                'Xem ảnh',
                textAlign: TextAlign.start,
                style: AppText.style.regularBlack14.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: 0.5,
            width: double.infinity,
          ),
          TouchableOpacity(
            onTap: onPickImage,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              alignment: Alignment.centerLeft,
              child: Text(
                'Thay đổi ảnh ${imageType == ImageType.avatar ? 'đại diện' : 'bìa'}',
                textAlign: TextAlign.start,
                style: AppText.style.regularBlack14.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
