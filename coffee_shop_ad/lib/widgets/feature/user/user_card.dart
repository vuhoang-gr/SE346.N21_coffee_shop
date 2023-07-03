import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_shop_admin/services/apis/firestore_references.dart';
import 'package:coffee_shop_admin/services/models/user.dart';
import 'package:coffee_shop_admin/utils/colors/app_colors.dart';
import 'package:coffee_shop_admin/utils/constants/dimension.dart';
import 'package:coffee_shop_admin/utils/styles/app_texts.dart';
import 'package:coffee_shop_admin/widgets/global/buttons/touchable_opacity.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class UserCard extends StatefulWidget {
  UserCard({super.key, required this.user});
  User user;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> with SingleTickerProviderStateMixin {
  late User user;

  late AnimationController swipeController;
  late Animation<Offset> swipeAnimation;
  late String imageUrl = user.avatarUrl;

  @override
  void initState() {
    super.initState();
    swipeController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    swipeAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(-0.5, 0))
        .animate(CurvedAnimation(parent: swipeController, curve: Curves.linear));
    user = widget.user;
  }

  @override
  void dispose() {
    super.dispose();
    swipeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = widget.user;
    Color adminColor = user.isAdmin ? AppColors.greenColor : AppColors.redColor;
    Color adminOppositeColor = adminColor == AppColors.greenColor ? AppColors.redColor : AppColors.greenColor;
    Color staffColor = user.isStaff ? AppColors.greenColor : AppColors.redColor;
    Color staffOppositeColor = staffColor == AppColors.greenColor ? AppColors.redColor : AppColors.greenColor;
    return Stack(
      children: [
        SlideTransition(
          position: swipeAnimation,
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx < -5 && swipeController.status == AnimationStatus.dismissed) {
                swipeController.forward();
              } else if (details.delta.dx > 5 && swipeController.status == AnimationStatus.completed) {
                swipeController.reverse();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: user.avatarUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(
                    width: Dimension.width10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: AppText.style.boldBlack16.copyWith(
                            color: AppColors.blueColor,
                          ),
                        ),
                        Text(
                          user.email,
                          style: AppText.style.regularGrey14.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              (user.isAdmin || user.isStaff) ? "Role: " : "Role: Normal User",
                              style: AppText.style.regularGrey14.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                                user.isAdmin
                                    ? 'Admin${user.isStaff ? " | Staff" : ""}'
                                    : user.isStaff
                                        ? "Staff"
                                        : "",
                                style: AppText.style.boldBlack14)
                          ],
                        ),
                      ],
                    ),
                  ),
                  TouchableOpacity(
                    opacity: 0.1,
                    onTap: () {
                      if (swipeController.status == AnimationStatus.completed) {
                        swipeController.reverse();
                      } else if (swipeController.status == AnimationStatus.dismissed) {
                        swipeController.forward();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.arrow_circle_left,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //fill all the stack for layoutBuilder contraints
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraint) {
              return AnimatedBuilder(
                animation: swipeController,
                builder: (context, child) {
                  //Positioned just work in stack
                  return Stack(
                    children: [
                      //Align widget to the right and take all the height
                      Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          width: constraint.maxWidth * swipeAnimation.value.dx * -1,
                          child: Row(
                            children: [
                              SizedBox(
                                width: constraint.maxWidth / 4 - 1,
                                child: TouchableOpacity(
                                  onTap: () async {
                                    QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.loading,
                                        title: "Setting role",
                                        text: user.isAdmin ? "Removing Admin role" : "Adding Admin role");
                                    await userReference.doc(user.id).update({
                                      "isAdmin": !user.isAdmin,
                                    }).then((value) {
                                      Navigator.pop(context);
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        title: "Done!",
                                        text: user.isAdmin ? "Removed Admin role!" : "This user is Admin now!",
                                        confirmBtnText: "Ok",
                                      );
                                    });

                                    setState(() {
                                      user.isAdmin = !user.isAdmin;
                                    });
                                    swipeController.reverse();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: adminOppositeColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          user.isAdmin
                                              ? Icons.admin_panel_settings
                                              : Icons.admin_panel_settings_outlined,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          user.isAdmin ? "unAdmin" : "setAdmin",
                                          style: AppText.style.mediumWhite12,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2),
                              SizedBox(
                                  width: constraint.maxWidth / 4 - 1,
                                  child: TouchableOpacity(
                                    onTap: () async {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.loading,
                                          title: "Setting role",
                                          text: user.isStaff ? "Removing Staff role" : "Adding Staff role");
                                      await userReference.doc(user.id).update({
                                        "isStaff": !user.isStaff,
                                      }).then((value) {
                                        Navigator.pop(context);
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          title: "Done!",
                                          text: user.isStaff ? "Removed Staff role!" : "This user is Staff now!",
                                          confirmBtnText: "Ok",
                                        );
                                      });
                                      setState(() {
                                        user.isStaff = !user.isStaff;
                                      });
                                      swipeController.reverse();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: staffOppositeColor,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            user.isStaff ? Icons.people_alt : Icons.people_alt_outlined,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            user.isStaff ? "unStaff" : "setStaff",
                                            style: AppText.style.mediumWhite12,
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          )),
                    ],
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
