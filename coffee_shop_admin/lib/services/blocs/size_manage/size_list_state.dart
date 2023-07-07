import 'package:coffee_shop_admin/services/models/size.dart';

abstract class SizeListState {
  SizeListState();
}

class LoadingState extends SizeListState {
  LoadingState();
}

class ErrorState extends SizeListState {
  ErrorState();
}

class LoadedState extends SizeListState {
  final List<Size> sizeList;
  LoadedState({required this.sizeList});
}
