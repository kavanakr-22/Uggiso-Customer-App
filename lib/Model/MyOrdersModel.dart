class MyOrdersModel {
  int? statusCode;
  String? message;
  List<Payload>? payload;
  String? timeStamp;
  String? error;

  MyOrdersModel({this.statusCode, this.message, this.payload, this.timeStamp});

  MyOrdersModel.fromJson(Map<String, dynamic> json) {
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

  MyOrdersModel.withError(String errorMessage) {
    error = errorMessage;
  }
}

class Payload {
  String? orderId;
  String? restaurantId;
  String? orderNumber;
  String? verifyCode;
  String? restaurantName;
  String? customerId;
  List<Menus>? menus;
  String? paymentType;
  String? orderStatus;
  String? orderType;
  String? travelMode;
  String? timeSlot;
  double? totalAmount;
  double? paidAmount;
  int? usedCoins;
  double? discount;
  String? comments;
  String? orderDate;
  String? orderTime;
  double? lat;
  double? lng;

  Payload(
      {this.orderId,
        this.restaurantId,
        this.orderNumber,
        this.verifyCode,
        this.restaurantName,
        this.customerId,
        this.menus,
        this.paymentType,
        this.orderStatus,
        this.orderType,
        this.travelMode,
        this.timeSlot,
        this.totalAmount,
        this.paidAmount,
        this.usedCoins,
        this.discount,
        this.comments,
        this.orderDate,
        this.orderTime,
        this.lat,
        this.lng});

  Payload.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    restaurantId = json['restaurantId'];
    orderNumber = json['orderNumber'];
    verifyCode = json['verifyCode'];
    restaurantName = json['restaurantName'];
    customerId = json['customerId'];
    if (json['menus'] != null) {
      menus = <Menus>[];
      json['menus'].forEach((v) {
        menus!.add(new Menus.fromJson(v));
      });
    }
    paymentType = json['paymentType'];
    orderStatus = json['orderStatus'];
    orderType = json['orderType'];
    travelMode = json['travelMode'];
    timeSlot = json['timeSlot'];
    totalAmount = json['totalAmount'];
    paidAmount = json['paidAmount'];
    usedCoins = json['usedCoins'];
    discount = json['discount'];
    comments = json['comments'];
    orderDate = json['orderDate'];
    orderTime = json['orderTime'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['restaurantId'] = this.restaurantId;
    data['orderNumber'] = this.orderNumber;
    data['verifyCode'] = this.verifyCode;
    data['restaurantName'] = this.restaurantName;
    data['customerId'] = this.customerId;
    if (this.menus != null) {
      data['menus'] = this.menus!.map((v) => v.toJson()).toList();
    }
    data['paymentType'] = this.paymentType;
    data['orderStatus'] = this.orderStatus;
    data['orderType'] = this.orderType;
    data['travelMode'] = this.travelMode;
    data['timeSlot'] = this.timeSlot;
    data['totalAmount'] = this.totalAmount;
    data['paidAmount'] = this.paidAmount;
    data['usedCoins'] = this.usedCoins;
    data['discount'] = this.discount;
    data['comments'] = this.comments;
    data['orderDate'] = this.orderDate;
    data['orderTime'] = this.orderTime;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Menus {
  String? menuId;
  String? menuName;
  String? photo;
  String? restaurantMenuType;
  double? quantityAmount;
  int? quantity;
  double? parcelAmount;

  Menus(
      {this.menuId,
        this.menuName,
        this.photo,
        this.restaurantMenuType,
        this.quantityAmount,
        this.quantity,
        this.parcelAmount});

  Menus.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    menuName = json['menuName'];
    photo = json['photo'];
    restaurantMenuType = json['restaurantMenuType'];
    quantityAmount = json['quantityAmount'];
    quantity = json['quantity'];
    parcelAmount = json['parcelAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuId'] = this.menuId;
    data['menuName'] = this.menuName;
    data['photo'] = this.photo;
    data['restaurantMenuType'] = this.restaurantMenuType;
    data['quantityAmount'] = this.quantityAmount;
    data['quantity'] = this.quantity;
    data['parcelAmount'] = this.parcelAmount;
    return data;
  }
}
