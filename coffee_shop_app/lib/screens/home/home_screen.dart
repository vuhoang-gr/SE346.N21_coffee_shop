import 'package:flutter/material.dart';

import '../../services/functions/shared_preferences_helper.dart';
import '../../services/models/food.dart';
import '../../temp/data.dart';
import '../../utils/colors/app_colors.dart';
import '../../utils/constants/dimension.dart';
import '../../utils/styles/app_texts.dart';
import '../../widgets/global/cart_button.dart';
import '../../widgets/global/custom_app_bar.dart';
import '../../widgets/global/order_type_picker.dart';
import '../../widgets/global/product_item.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int durationChange = 200;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollInTop = true;

  Future<List<Widget>> _generateProducts() async {
    List<String> productsid = await SharedPreferencesHelper.getProducts();
    List<Widget> products = <Widget>[];
    for (int i = 0; i < productsid.length; i++) {
      Food? food =
          Data.products.firstWhere((element) => element.id == productsid[i]);
//TODO: Check the food is null
      products.add(ProductItem(
          id: food.id,
          productName: food.name,
          productPrice: food.price,
          imageProduct: food.images.first,
          dateRegister: DateTime(2023, 29, 3, 12)));
    }
    return products;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.offset <= 0 && !_isScrollInTop) {
        setState(() {
          _isScrollInTop = true;
        });
      } else if (_scrollController.offset > 0 && _isScrollInTop) {
        setState(() {
          _isScrollInTop = false;
        });
      }
    });

    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              children: [
                CustomAppBar(
                  color:
                      _isScrollInTop ? AppColors.backgroundColor : Colors.white,
                  leading: Row(
                    crossAxisAlignment: _isScrollInTop
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        height: Dimension.height40,
                        width: _isScrollInTop ? Dimension.height40 : 0,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimension.height20))),
                        duration: Duration(milliseconds: durationChange),
                      ),
                      AnimatedContainer(
                        width: _isScrollInTop ? Dimension.width12 : 0,
                        duration: Duration(milliseconds: durationChange),
                      ),
                      Column(
                        mainAxisAlignment: _isScrollInTop
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: durationChange),
                            height: _isScrollInTop ? Dimension.height20 : 0,
                            child: Text(
                              "Welcome to",
                              style: AppText.style.regular,
                            ),
                          ),
                          AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: durationChange),
                            style: _isScrollInTop
                                ? AppText.style.boldBlack14
                                : AppText.style.boldBlack18,
                            child: const Text(
                              "Sample restaurant",
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListView(controller: _scrollController, children: [
                        SizedBox(
                          height: Dimension.height24,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimension.width16),
                          child: const OrderTypePicker(),
                        ),
                        SizedBox(
                          height: Dimension.height24,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimension.width16),
                          child: Text(
                            "Used recently",
                            style: AppText.style.boldBlack16,
                          ),
                        ),
                        SizedBox(
                          height: Dimension.height12,
                        ),
                        FutureBuilder(
                            future: _generateProducts(),
                            builder: (context, snapshot) {
                              return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimension.width16),
                                  child: ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, index) {
                                        return snapshot.data == null
                                            ? const SizedBox()
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: snapshot.data![index]);
                                      },
                                      separatorBuilder: (ctx, index) {
                                        return SizedBox(
                                          height: Dimension.height8,
                                        );
                                      },
                                      itemCount: snapshot.data == null
                                          ? 0
                                          : snapshot.data!.length)
                                  // child: Column(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  //   children: snapshot.data ?? <Widget>[],
                                  // ),
                                  );
                            }),
                        SizedBox(
                          height: Dimension.height20,
                        )
                      ]),
                      CartButton(scrollController: _scrollController, money: 56000, amount: 1,)
                    ],
                  ),
                ),
              ],
            )));
  }
}
