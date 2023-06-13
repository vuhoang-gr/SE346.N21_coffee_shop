import 'package:coffee_shop_app/services/blocs/pickup_timer/pickup_timer_state.dart';
import 'package:coffee_shop_app/services/functions/datetime_to_pickup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<PickupTimerState> {
  TimerCubit()
      : super(PickupTimerState(hourStartTime: dateTimeToHour(DateTime.now()))
            .copyWith());

  setDateTime({DateTime? newDate, int? hour, int? minute}) {
    var now = DateTime.now();
    if (newDate != null) {
      if (newDate.year != now.year ||
          newDate.month != now.month ||
          newDate.day != now.day) {
        emit(state.copyWith(
            newDate: newDate,
            hour: hour,
            minute: minute,
            hourStartTime: dateTimeToHour(state.openTime!)));
      } else {
        emit(state.copyWith(newDate: newDate, hour: hour, minute: minute));
        setTimer();
      }
    }
    emit(state.copyWith(newDate: newDate, hour: hour, minute: minute));
  }

  setOpenTime(DateTime? openTime) {
    emit(state.copyWith(openTime: openTime));

    if (state.selectedDate!.day == DateTime.now().day) {
      if (state.selectedDate!.hour < openTime!.hour ||
          (state.selectedDate!.hour == openTime.hour &&
              state.selectedDate!.minute < openTime.minute)) {
        emit(PickupTimerState(hourStartTime: dateTimeToHour(state.openTime!))
            .copyWith(openTime: state.openTime));
        return;
      }
    }
  }

  setSelectedDate(DateTime? selectedDate) {
    emit(state.copyWith(selectedDate: selectedDate));
  }

  setTimer() {
    var hourStartTime = dateTimeToHour(DateTime.now());
    var startHour = (hourStartTime / 2).floor();
    var startMinute = hourStartTime % 2 * 30;

    if (state.newDate!.day == DateTime.now().day) {
      if (state.newDate!.hour < startHour ||
          (state.newDate!.hour == startHour &&
              state.newDate!.minute < startMinute)) {
        emit(PickupTimerState(
                hourStartTime: hourStartTime, selectedDate: state.selectedDate)
            .copyWith(openTime: state.openTime));
        return;
      }
    }
    if (state.selectedDate!.day == DateTime.now().day) {
      if (state.selectedDate!.hour < startHour ||
          (state.selectedDate!.hour == startHour &&
              state.selectedDate!.minute < startMinute)) {
        emit(PickupTimerState(hourStartTime: hourStartTime)
            .copyWith(openTime: state.openTime));
        return;
      }
    }
  }
}
