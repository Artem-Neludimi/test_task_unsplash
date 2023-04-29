part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeChangeTitleEvent extends HomeEvent {
  final int index;

  HomeChangeTitleEvent(this.index);
}

class HomeNewPageEvent extends HomeEvent {}
