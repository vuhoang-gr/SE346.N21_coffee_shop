import '../../models/size.dart';

abstract class SizeStoreEvent {}

class FetchData extends SizeStoreEvent {}

class GetDataFetched extends SizeStoreEvent {
  final List<Size> listSizes;
  GetDataFetched({required this.listSizes});
}
