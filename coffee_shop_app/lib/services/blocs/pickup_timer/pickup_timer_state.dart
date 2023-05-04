import 'package:equatable/equatable.dart';

class PickupTimerState extends Equatable {
  final int hourStartTime;
  final DateTime? selectedDate;
  const PickupTimerState({required this.hourStartTime, this.selectedDate});

  PickupTimerState copyWith({DateTime? selectedDate, int? hour, int? minute}) {
    var now = DateTime.now();
    var date = selectedDate ?? now;
    var hourStartTime = now.hour * 2 + (now.minute > 30 ? 2 : 1);

    return (PickupTimerState(
        hourStartTime: hourStartTime,
        selectedDate: DateTime(
            date.year,
            date.month,
            date.day,
            hour ?? (hourStartTime / 2).floor(),
            minute ?? (now.minute <= 30 ? 30 : 0))));
  }

  @override
  // TODO: implement props
  List<Object?> get props => [hourStartTime, selectedDate];
}
