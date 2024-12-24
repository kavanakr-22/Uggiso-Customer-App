class AddFavoriteMenuModel {
  int? statusCode;
  String? message;
  List<dynamic>? payload; // Changed from List<Null> to List<dynamic>
  String? timeStamp;
  String? error;


  AddFavoriteMenuModel({
    this.statusCode,
    this.message,
    this.payload,
    this.timeStamp,
  });

  AddFavoriteMenuModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['payload'] != null) {
      payload = List<dynamic>.from(json['payload']);
    }
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (payload != null) {
      data['payload'] = payload;
    }
    data['timeStamp'] = timeStamp;
    return data;
  }

  AddFavoriteMenuModel.withError(String errorMessage) {
    error = errorMessage;
  }
}
