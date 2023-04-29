part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadPhotosState extends HomeState {
  final List<PhotoModel> photos;
  final bool isChangedTitle;

  HomeLoadPhotosState(this.photos, this.isChangedTitle);
}

class ErrorState extends HomeState {
  final String errorMessage;

  ErrorState({
    required this.errorMessage,
  });
}
