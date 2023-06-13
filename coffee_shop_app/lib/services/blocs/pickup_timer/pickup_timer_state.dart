import 'package:coffee_shop_app/services/functions/datetime_to_pickup.dart';
import 'package:equatable/equatable.dart';

class PickupTimerState extends Equatable {
  final int hourStartTime;
  final DateTime? newDate;
  final DateTime? openTime;
  final DateTime? selectedDate;
  const PickupTimerState(
      {required this.hourStartTime,
      this.newDate,
      this.openTime,
      this.selectedDate});

  PickupTimerState copyWith(
      {DateTime? newDate,
      DateTime? selectedDate,
      int? hour,
      int? minute,
      int? hourStartTime,
      DateTime? openTime}) {
    var now = DateTime.now();
    var date = newDate ?? now;
    if (openTime != null || this.openTime != null) {
      if ((hourStartTime ?? this.hourStartTime) <
          dateTimeToHour(openTime ?? this.openTime!)) {
        hourStartTime = dateTimeToHour(openTime ?? this.openTime!);
      }
    }

    var newSelect = DateTime(
        date.year,
        date.month,
        date.day,
        hour ?? (hourStartTime ?? this.hourStartTime / 2).floor(),
        minute ?? ((hourStartTime ?? this.hourStartTime) % 2 == 1 ? 30 : 0));
    return (PickupTimerState(
        hourStartTime: hourStartTime ?? this.hourStartTime,
        openTime: openTime ?? this.openTime,
        selectedDate: selectedDate ?? (this.selectedDate ?? newSelect),
        newDate: newSelect));
  }

  @override
  // TODO: implement props
  List<Object?> get props => [hourStartTime, newDate, openTime, selectedDate];
}
