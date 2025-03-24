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
  String? ownerId;
  String? restaurantName;
  String? ownerName;
  String? phoneNumber;
  String? contactNumber;
  String? address;
  String? landmark;
  double? lat;
  double? lng;
  String? city;
  String? state;
  String? accountNumber;
  String? ifscCode;
  String? upiData;
  String? imageUrl;
  String? gstNumber;
  double? gstPercent;
  Null? openTime;
  Null? closeTime;
  String? userStatus;
  String? restaurantMenuType;
  String? restaurantSize;
  double? ratings;
  double? subscriptionAmount;
  double? platformpercentage;
  String? subsriptionDate;
  String? fssai;
  String? panImage;
  List<dynamic>? menucard;
  String? chequePhoto;
  Null? onboardDoc;
  Null? agreementDoc;
  bool? referAdded;
  String? ownerPhone;
  String? createdDate;

  Restaurants(
      {this.restaurantId,
        this.ownerId,
        this.restaurantName,
        this.ownerName,
        this.phoneNumber,
        this.contactNumber,
        this.address,
        this.landmark,
        this.lat,
        this.lng,
        this.city,
        this.state,
        this.accountNumber,
        this.ifscCode,
        this.upiData,
        this.imageUrl,
        this.gstNumber,
        this.gstPercent,
        this.openTime,
        this.closeTime,
        this.userStatus,
        this.restaurantMenuType,
        this.restaurantSize,
        this.ratings,
        this.subscriptionAmount,
        this.platformpercentage,
        this.subsriptionDate,
        this.fssai,
        this.panImage,
        this.menucard,
        this.chequePhoto,
        this.onboardDoc,
        this.agreementDoc,
        this.referAdded,
        this.ownerPhone,
        this.createdDate});

  Restaurants.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurantId'];
    ownerId = json['ownerId'];
    restaurantName = json['restaurantName'];
    ownerName = json['ownerName'];
    phoneNumber = json['phoneNumber'];
    contactNumber = json['contactNumber'];
    address = json['address'];
    landmark = json['landmark'];
    lat = json['lat'];
    lng = json['lng'];
    city = json['city'];
    state = json['state'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'];
    upiData = json['upiData'];
    imageUrl = json['imageUrl'];
    gstNumber = json['gstNumber'];
    gstPercent = json['gstPercent'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    userStatus = json['userStatus'];
    restaurantMenuType = json['restaurantMenuType'];
    restaurantSize = json['restaurantSize'];
    ratings = json['ratings'];
    subscriptionAmount = json['subscriptionAmount'];
    platformpercentage = json['platformpercentage'];
    subsriptionDate = json['subsriptionDate'];
    fssai = json['fssai'];
    panImage = json['panImage'];
    menucard = json['menucard'];
    chequePhoto = json['chequePhoto'];
    onboardDoc = json['onboardDoc'];
    agreementDoc = json['agreementDoc'];
    referAdded = json['referAdded'];
    ownerPhone = json['ownerPhone'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurantId'] = this.restaurantId;
    data['ownerId'] = this.ownerId;
    data['restaurantName'] = this.restaurantName;
    data['ownerName'] = this.ownerName;
    data['phoneNumber'] = this.phoneNumber;
    data['contactNumber'] = this.contactNumber;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['city'] = this.city;
    data['state'] = this.state;
    data['accountNumber'] = this.accountNumber;
    data['ifscCode'] = this.ifscCode;
    data['upiData'] = this.upiData;
    data['imageUrl'] = this.imageUrl;
    data['gstNumber'] = this.gstNumber;
    data['gstPercent'] = this.gstPercent;
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['userStatus'] = this.userStatus;
    data['restaurantMenuType'] = this.restaurantMenuType;
    data['restaurantSize'] = this.restaurantSize;
    data['ratings'] = this.ratings;
    data['subscriptionAmount'] = this.subscriptionAmount;
    data['platformpercentage'] = this.platformpercentage;
    data['subsriptionDate'] = this.subsriptionDate;
    data['fssai'] = this.fssai;
    data['panImage'] = this.panImage;
    data['menucard'] = this.menucard;
    data['chequePhoto'] = this.chequePhoto;
    data['onboardDoc'] = this.onboardDoc;
    data['agreementDoc'] = this.agreementDoc;
    data['referAdded'] = this.referAdded;
    data['ownerPhone'] = this.ownerPhone;
    data['createdDate'] = this.createdDate;
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
  Null? ratings;

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
