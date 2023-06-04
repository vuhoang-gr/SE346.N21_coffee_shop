import 'package:coffee_shop_admin/services/blocs/pickup_timer/pickup_timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<PickupTimerState> {
  TimerCubit()
      : super(PickupTimerState(
                hourStartTime: DateTime.now().hour * 2 +
                    (DateTime.now().minute > 30 ? 2 : 1))
            .copyWith());

  setDateTime({DateTime? selectedDate, int? hour, int? minute}) {
    emit(
        state.copyWith(selectedDate: selectedDate, hour: hour, minute: minute));
  }

  setTimer() {
    var hourStartTime =
        DateTime.now().hour * 2 + (DateTime.now().minute > 30 ? 2 : 1);
    // var hourStartTime = state.hourStartTime + 1;

    var startHour = (hourStartTime / 2).floor();
    var startMinute = hourStartTime % 2 * 30;

    if (state.selectedDate!.day == DateTime.now().day) {
      if (state.selectedDate!.hour < startHour ||
          (state.selectedDate!.hour == startHour &&
              state.selectedDate!.minute < startMinute)) {
        emit(PickupTimerState(hourStartTime: hourStartTime).copyWith());
      }
    }

    emit(PickupTimerState(
        hourStartTime: hourStartTime, selectedDate: state.selectedDate));
  }
}
