import 'package:dio/dio.dart';

import '../models/photo_models.dart';

class PhotoClient {
  Future<List<PhotoModel>> getPhotos(String title, int page) async {
    final List<PhotoModel> photos = [];
    try {
      Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      final response = await dio
          .get(
              'https://api.unsplash.com/search/photos?per_page=30&page=$page&client_id=l42RxGnoGt9UXyr41cAnN-f0Wc256tOQtPpL0V_Tnag&query=$title',
              options: Options(responseType: ResponseType.json, method: 'GET'))
          .then((response) {
        return response.data['results'];
      });
      for (var element in response) {
        photos.add(PhotoModel.fromJson(element));
      }
      return photos;
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        throw Exception(e.response);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
