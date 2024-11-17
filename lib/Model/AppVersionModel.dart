class AppVersionModel {
  int? statusCode;
  String? message;
  Payload? payload;
  String? timeStamp;
  String? error;

  AppVersionModel(
      {this.statusCode, this.message, this.payload, this.timeStamp});

  AppVersionModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    data['timeStamp'] = this.timeStamp;
    return data;
  }
  AppVersionModel.withError(String errorMessage) {
    error = errorMessage;
  }
}

class Payload {
  String? latestVersion;
  String? updateUrl;
  bool? mandatoryUpdate;

  Payload({this.latestVersion, this.updateUrl, this.mandatoryUpdate});

  Payload.fromJson(Map<String, dynamic> json) {
    latestVersion = json['latestVersion'];
    updateUrl = json['updateUrl'];
    mandatoryUpdate = json['mandatoryUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latestVersion'] = this.latestVersion;
    data['updateUrl'] = this.updateUrl;
    data['mandatoryUpdate'] = this.mandatoryUpdate;
    return data;
  }
}
