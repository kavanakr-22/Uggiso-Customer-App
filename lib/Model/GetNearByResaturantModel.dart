class GetNearByRestaurantModel {
  int? statusCode;
  String? message;
  List<Payload>? payload;
  String? timeStamp;
  String? error;

  GetNearByRestaurantModel(
      {this.statusCode, this.message, this.payload, this.timeStamp});

  GetNearByRestaurantModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['payload'] != null) {
      payload = <Payload>[];
      json['payload'].forEach((v) {
        payload!.add(Payload.fromJson(v));
      });
    }
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    data['timeStamp'] = this.timeStamp;
    return data;
  }

  GetNearByRestaurantModel.withError(String errorMessage) {
    error = errorMessage;
  }

  GetNearByRestaurantModel copyWith({
    int? statusCode,
    String? message,
    List<Payload>? payload,
    String? timeStamp,
    String? error,
  }) {
    return GetNearByRestaurantModel(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      payload: payload ?? this.payload,
      timeStamp: timeStamp ?? this.timeStamp,
    )..error = error ?? this.error;
  }
}

class Payload {
  String? restaurantId;
  String? restaurantName;
  String? restaurantMenuType;
  String? phoneNumber;
  String? address;
  String? landmark;
  double? lat;
  double? lng;
  double? ratings;
  String? duration;
  String? distance;
  String? imageUrl;
  bool? favourite;
  double? gstPercent;
  double? serviceCharges; // ✅ New field added

  Payload({
    this.restaurantId,
    this.restaurantName,
    this.restaurantMenuType,
    this.phoneNumber,
    this.address,
    this.landmark,
    this.lat,
    this.lng,
    this.ratings,
    this.duration,
    this.distance,
    this.imageUrl,
    this.favourite,
    this.gstPercent,
    this.serviceCharges, // ✅ Constructor updated
  });

  Payload.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    restaurantName = json['restaurantName'];
    restaurantMenuType = json['restaurantMenuType'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    landmark = json['landmark'];
    lat = json['lat'];
    lng = json['lng'];
    ratings = json['ratings'] != null ? json['ratings'].toDouble() : null;
    duration = json['duration'];
    distance = json['distance'];
    imageUrl = json['imageUrl'];
    favourite = json['favourite'];
    gstPercent =
        json['gstPercent'] != null ? json['gstPercent'].toDouble() : null;
    serviceCharges = json['serviceCharges'] != null
        ? json['serviceCharges'].toDouble()
        : null; // ✅ Parsing new field
  }

  get price => null;

  get rating => null;

  get type => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['restaurantId'] = this.restaurantId;
    data['restaurantName'] = this.restaurantName;
    data['restaurantMenuType'] = this.restaurantMenuType;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['ratings'] = this.ratings;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    data['imageUrl'] = this.imageUrl;
    data['favourite'] = this.favourite;
    data['gstPercent'] = this.gstPercent;
    data['serviceCharges'] = this.serviceCharges; // ✅ New field in toJson
    return data;
  }
}
