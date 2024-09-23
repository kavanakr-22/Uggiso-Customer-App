class AcceptorsListModel {
  int? statusCode;
  String? message;
  List<Payload>? payload;
  String? timeStamp;
  String? error;

  AcceptorsListModel(
      {this.statusCode, this.message, this.payload, this.timeStamp});

  AcceptorsListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['payload'] != null) {
      payload = <Payload>[];
      json['payload'].forEach((v) {
        payload!.add(new Payload.fromJson(v));
      });
    }
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    data['timeStamp'] = this.timeStamp;
    return data;
  }

  AcceptorsListModel.withError(String errorMessage) {
    error = errorMessage;
  }
}

class Payload {
  String? introducerId;
  String? acceptorName;
  String? referenceType;
  int? availedCoins;
  bool? addedToWallet;
  String? referedDate;

  Payload(
      {this.introducerId,
        this.acceptorName,
        this.referenceType,
        this.availedCoins,
        this.addedToWallet,
        this.referedDate});

  Payload.fromJson(Map<String, dynamic> json) {
    introducerId = json['introducerId'];
    acceptorName = json['acceptorName'];
    referenceType = json['referenceType'];
    availedCoins = json['availedCoins'];
    addedToWallet = json['addedToWallet'];
    referedDate = json['referedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['introducerId'] = this.introducerId;
    data['acceptorName'] = this.acceptorName;
    data['referenceType'] = this.referenceType;
    data['availedCoins'] = this.availedCoins;
    data['addedToWallet'] = this.addedToWallet;
    data['referedDate'] = this.referedDate;
    return data;
  }
}
