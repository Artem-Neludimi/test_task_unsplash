class PhotoModel {
  Map<String, dynamic>? user;
  Map<String, dynamic>? urls;
  String? description;

  PhotoModel({this.urls, this.user, this.description});

  PhotoModel.fromJson(Map<String, dynamic> json) {
    urls = json['urls'];
    user = json['user'];
    description = json['description'];
  }
}
