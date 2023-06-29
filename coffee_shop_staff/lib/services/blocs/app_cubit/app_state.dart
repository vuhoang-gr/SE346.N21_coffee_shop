part of 'app_cubit.dart';

@immutable
abstract class AppState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppLoading extends AppState {}

class AppLoaded extends AppState {}
