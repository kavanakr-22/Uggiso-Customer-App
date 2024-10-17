class InitiatePaymentModel {
  int? statusCode;
  String? message;
  Payload? payload;
  String? timeStamp;
  String? error;

  InitiatePaymentModel(
      {this.statusCode, this.message, this.payload, this.timeStamp});

  InitiatePaymentModel.fromJson(Map<String, dynamic> json) {
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

  InitiatePaymentModel.withError(String errorMessage) {
    error = errorMessage;
  }
}

class Payload {
  int? status;
  Null? errorDesc;
  String? data;

  Payload({this.status, this.errorDesc, this.data});

  Payload.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorDesc = json['error_desc'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error_desc'] = this.errorDesc;
    data['data'] = this.data;
    return data;
  }
}
