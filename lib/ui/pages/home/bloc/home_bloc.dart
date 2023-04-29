import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_task_unsplash/constants.dart';

import '../../../../networking/client/photo_client.dart';
import '/../networking/models/photo_models.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PhotoClient _apiServicePhoto;

  int page = 1;
  String title = Constants.titles.first;
  late List<PhotoModel> photos;
  HomeBloc(this._apiServicePhoto) : super(HomeInitial()) {
    on<HomeChangeTitleEvent>(_onChangeTitle);
    on<HomeNewPageEvent>(_onNewPage);
    _init();
  }
  Future<void> _init() async {
    try {
      photos = await _apiServicePhoto.getPhotos(title, page);
      if (photos.isNotEmpty) {
        emit(HomeLoadPhotosState(photos, false));
      } else {
        emit(ErrorState(errorMessage: 'Something went wrong'));
      }
    } catch (error) {
      emit(ErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onChangeTitle(
    HomeChangeTitleEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (title != Constants.titles[event.index]) {
        page = 1;
        title = Constants.titles[event.index];
        photos = await _apiServicePhoto.getPhotos(title, page);
      }
      if (photos.isNotEmpty) {
        emit(HomeLoadPhotosState(photos, true));
      } else {
        emit(ErrorState(errorMessage: 'Something went wrong'));
      }
    } catch (error) {
      emit(ErrorState(errorMessage: error.toString()));
    }
  }

  Future<void> _onNewPage(
    HomeNewPageEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      page++;
      photos.addAll(await _apiServicePhoto.getPhotos(title, page));
      if (photos.isNotEmpty) {
        emit(HomeLoadPhotosState(photos, false));
      } else {
        emit(ErrorState(errorMessage: 'Something went wrong'));
      }
    } catch (error) {
      emit(ErrorState(errorMessage: error.toString()));
    }
  }
}
