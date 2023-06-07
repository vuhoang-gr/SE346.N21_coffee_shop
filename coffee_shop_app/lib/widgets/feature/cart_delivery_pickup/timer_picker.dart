import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../services/blocs/cart_button/cart_button_bloc.dart';
import '../../../services/blocs/pickup_timer/pickup_timer_cubit.dart';
import '../../../services/blocs/pickup_timer/pickup_timer_state.dart';
import '../../../services/functions/datetime_to_pickup.dart';
import '../../../utils/colors/app_colors.dart';
import '../../../utils/constants/dimension.dart';
import '../../../utils/styles/app_texts.dart';
import '../../../utils/styles/button.dart';

class TimerPicker extends StatelessWidget {
  const TimerPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerCubit, PickupTimerState>(builder: (context, state) {
      var timeClose = dateTimeToHour(BlocProvider.of<CartButtonBloc>(context)
          .state
          .selectedStore!
          .timeClose);
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Dimension.height8,
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Pickup time',
                    style: AppText.style.boldBlack16,
                  ),
                )
              ],
            ),
            const Divider(
              thickness: 1,
              color: AppColors.greyBoxColor,
            ),

            //the time picker
            SizedBox(
              height: Dimension.heightTimePicker,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.maxFinite,
                        height: Dimension.height24,
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: AppColors.greyBoxColor, width: 1),
                                bottom: BorderSide(
                                    color: AppColors.greyBoxColor, width: 1))),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                            onSelectedItemChanged: (value) {
                              var date =
                                  (DateTime.now().add(Duration(days: value)));
                              BlocProvider.of<TimerCubit>(context)
                                  .setDateTime(newDate: date);
                            },
                            physics: const FixedExtentScrollPhysics(),
                            itemExtent: Dimension.height24,
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 3,
                                builder: (context, index) {
                                  String day;
                                  if (index == 0) {
                                    day = 'Today';
                                  } else if (index == 1) {
                                    day = 'Tomorrow';
                                  } else {
                                    day = DateFormat('dd-MM-yyyy')
                                        .format((DateTime.now()
                                            .add(Duration(days: index))))
                                        .toString();
                                  }

                                  return Center(
                                    child: Text(
                                      day,
                                      style: AppText.style.boldBlack16,
                                    ),
                                  );
                                })),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                            onSelectedItemChanged: (value) {
                              int time = value + state.hourStartTime;
                              int hour = (time / 2).floor();
                              int minute = time % 2 * 30;
                              BlocProvider.of<TimerCubit>(context).setDateTime(
                                  newDate: state.newDate,
                                  hour: hour,
                                  minute: minute);
                            },
                            physics: const FixedExtentScrollPhysics(),
                            itemExtent: Dimension.height24,
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: (timeClose - state.hourStartTime),
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      indexToTime(index + state.hourStartTime),
                                      style: AppText.style.boldBlack16,
                                    ),
                                  );
                                })),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: Dimension.height16,
            ),
            const Divider(
              thickness: 1,
              color: AppColors.greyBoxColor,
            ),
            SizedBox(
              width: double.maxFinite,
              height: Dimension.height40,
              child: ElevatedButton(
                style: roundedButton,
                onPressed: () {
                  BlocProvider.of<TimerCubit>(context).setSelectedDate(
                      BlocProvider.of<TimerCubit>(context).state.newDate);
                  Navigator.pop(context);
                },
                child: Text(
                  'Apply',
                  style: AppText.style.regularWhite16,
                ),
              ),
            ),
            SizedBox(
              height: Dimension.height8,
            ),
          ],
        ),
      );
    });
  }
}
