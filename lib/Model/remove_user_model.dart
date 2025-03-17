class RemoveUserModel {
  int? statusCode;
  String? message;
  Null? payload;
  String? timeStamp;
  String? error;

  RemoveUserModel(
      {this.statusCode, this.message, this.payload, this.timeStamp});

  RemoveUserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    payload = json['payload'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['payload'] = this.payload;
    data['timeStamp'] = this.timeStamp;
    return data;
  }

  RemoveUserModel.withError(String errorMessage) {
    error = errorMessage;
  }
}
