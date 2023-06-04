import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_admin/screens/drink_management/size_card.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_bloc.dart';
import 'package:coffee_shop_admin/services/blocs/size_manage/size_list_event.dart';
import 'package:coffee_shop_admin/services/models/size.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/utils/styles/button.dart';
import 'package:coffee_shop_admin/widgets/global/custom_app_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';

class SizeDetail extends StatefulWidget {
  static const String routeName = "/size_detail_screen";
  final Size product;
  const SizeDetail({super.key, required this.product});

  @override
  State<SizeDetail> createState() => _SizeDetailState();
}

class _SizeDetailState extends State<SizeDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    // ignore: no_leading_underscores_for_local_identifiers
    void _handleOnTapDeleteSize() async {
      String imgUrl = widget.product.image;

      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Deleting ${widget.product.name}',
      );

      try {
        await FirebaseFirestore.instance
            .collection("Size")
            .doc(widget.product.id)
            .delete()
            .then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          BlocProvider.of<SizeListBloc>(context).add(FetchData());
          FirebaseStorage.instance.refFromURL(imgUrl).delete();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Completed Successfully!',
          );
        });
      } catch (e) {
        print("Something wrong when delete size");
        print(e);
      }
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ColoredBox(
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    leading: Text(
                      'Size: ${widget.product.name}',
                      style: AppText.style.regularBlack16,
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    children: [
                      SizeCard(product: widget.product),
                      SizedBox(height: 16)
                    ],
                  ))),

                  //add to cart bar
                  isKeyboard
                      ? const SizedBox()
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimension.height16,
                              vertical: Dimension.height8),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                height: Dimension.height40,
                                child: Builder(builder: (context) {
                                  return ElevatedButton(
                                      style: roundedButton,
                                      onPressed: _handleOnTapDeleteSize,
                                      child: Text(
                                        'Delete',
                                        style: AppText.style.regularWhite16,
                                      ));
                                }),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
