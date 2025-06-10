class ResaturantSearchModel {
  int? statusCode;
  String? message;
  Payload? payload;
  String? timeStamp;
  String? error;

  ResaturantSearchModel(
      {this.statusCode, this.message, this.payload, this.timeStamp});

  ResaturantSearchModel.fromJson(Map<String, dynamic> json) {
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
  ResaturantSearchModel.withError(String errorMessage) {
    error = errorMessage;
  }
}

class Payload {
  List<Restaurants>? restaurants;
  List<Menus>? menus;

  Payload({this.restaurants, this.menus});

  Payload.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      restaurants = <Restaurants>[];
      json['restaurants'].forEach((v) {
        restaurants!.add(new Restaurants.fromJson(v));
      });
    }
    if (json['menus'] != null) {
      menus = <Menus>[];
      json['menus'].forEach((v) {
        menus!.add(new Menus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants!.map((v) => v.toJson()).toList();
    }
    if (this.menus != null) {
      data['menus'] = this.menus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurants {
  String? restaurantId;
  String? restaurantName;
  String? imageUrl;
  String? restaurantMenuType;
  String? phoneNumber;
  String? address;
  String? landmark;
  double? lat;
  double? lng;
  double? ratings;
  String? duration;
  String? distance;
  bool? favourite;
  double? gstPercent;
  double? serviceCharges;

  Restaurants(
      {this.restaurantId,
        this.restaurantName,
        this.imageUrl,
        this.restaurantMenuType,
        this.phoneNumber,
        this.address,
        this.landmark,
        this.lat,
        this.lng,
        this.ratings,
        this.duration,
        this.distance,
        this.favourite,
        this.gstPercent,
        this.serviceCharges});

  Restaurants.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    restaurantName = json['restaurantName'];
    imageUrl = json['imageUrl'];
    restaurantMenuType = json['restaurantMenuType'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    landmark = json['landmark'];
    lat = json['lat'];
    lng = json['lng'];
    ratings = json['ratings'];
    duration = json['duration'];
    distance = json['distance'];
    favourite = json['favourite'];
    gstPercent = json['gstPercent'];
    serviceCharges = json['serviceCharges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['restaurantName'] = this.restaurantName;
    data['imageUrl'] = this.imageUrl;
    data['restaurantMenuType'] = this.restaurantMenuType;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['ratings'] = this.ratings;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    data['favourite'] = this.favourite;
    data['gstPercent'] = this.gstPercent;
    data['serviceCharges'] = this.serviceCharges;
    return data;
  }
}

class Menus {
  String? menuId;
  String? restaurantId;
  String? menuName;
  String? photo;
  String? description;
  String? menuType;
  String? menuStatus;
  String? menuAvailable;
  String? restaurantMenuType;
  double? price;
  double? parcelCharges;
  bool? bestSeller;
  double? ratings;

  Menus(
      {this.menuId,
        this.restaurantId,
        this.menuName,
        this.photo,
        this.description,
        this.menuType,
        this.menuStatus,
        this.menuAvailable,
        this.restaurantMenuType,
        this.price,
        this.parcelCharges,
        this.bestSeller,
        this.ratings});

  Menus.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    restaurantId = json['restaurantId'];
    menuName = json['menuName'];
    photo = json['photo'];
    description = json['description'];
    menuType = json['menuType'];
    menuStatus = json['menuStatus'];
    menuAvailable = json['menuAvailable'];
    restaurantMenuType = json['restaurantMenuType'];
    price = json['price'];
    parcelCharges = json['parcelCharges'];
    bestSeller = json['bestSeller'];
    ratings = json['ratings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuId'] = this.menuId;
    data['restaurantId'] = this.restaurantId;
    data['menuName'] = this.menuName;
    data['photo'] = this.photo;
    data['description'] = this.description;
    data['menuType'] = this.menuType;
    data['menuStatus'] = this.menuStatus;
    data['menuAvailable'] = this.menuAvailable;
    data['restaurantMenuType'] = this.restaurantMenuType;
    data['price'] = this.price;
    data['parcelCharges'] = this.parcelCharges;
    data['bestSeller'] = this.bestSeller;
    data['ratings'] = this.ratings;
    return data;
  }
}
