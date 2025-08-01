import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uggiso/Model/AcceptorsListModel.dart';
import 'package:uggiso/Model/AddFavoriteMenuModel.dart';
import 'package:uggiso/Model/AppVersionModel.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';
import 'package:uggiso/Model/GetRouteModel.dart';
import 'package:uggiso/Model/InitiatePaymentModel.dart';
import 'package:uggiso/Model/MenuListModel.dart';
import 'package:uggiso/Model/MyOrdersModel.dart';
import 'package:uggiso/Model/PaymentDetailsModel.dart';
import 'package:uggiso/Model/RegisterUserModel.dart';
import 'package:uggiso/Model/RestaurantByMenuTypeModel.dart';
import 'package:uggiso/Model/RestaurantDetailsModel.dart';
import 'package:uggiso/Model/RestaurantSearchModel.dart';
import 'package:uggiso/Model/UpdateOrderModel.dart';
import 'package:uggiso/Model/VerifyOtpModel.dart';
import 'package:uggiso/Model/otpModel.dart';
import 'package:uggiso/Model/remove_user_model.dart';
import 'package:uggiso/Network/constants.dart';

import '../Model/GetFavMenuModel.dart';
import '../Model/GetFavRestaurantModel.dart';
import '../Model/OrderCheckoutModel.dart';
import '../Model/RemoveFavRestaurantModel.dart';
import '../Model/SaveIntroducerModel.dart';
import '../Model/WalletDetailsModel.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = Constants.baseUrl;
  final options = Options(
    followRedirects: false,
    contentType: "application/json",
    validateStatus: (status) {
      return status != null && status >= 200 && status < 500;
    },
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "SECURE-API-KEY":
          "336924d18ed3718f48dc62b5ae3032afe387d5dc86685e5d43ad04bf2cc41f60",
    },
  );

  Future<OtpModel> getOtp(String number) async {
    try {
      Response response = await _dio.post(
        '${_url}${Constants.getOtp}',
        data: {"phoneNumber": number},
        options: options,
      );
      print("${response.data}");
      return OtpModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return OtpModel.withError("Data not found / Connection issue");
    }
  }

  Future<VerifyOtpModel> verifyOtp(String? number, String otp) async {
    print('this is rewuest : $number and $otp');
    try {
      Response response = await _dio.post(
        '${_url}${Constants.verifyOtp}',
        data: {"phoneNumber": number, "otp": otp},
        options: options,
      );
      print("${response.data}");

      return VerifyOtpModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return VerifyOtpModel.withError("Data not found / Connection issue");
    }
  }

  Future<RegisterUserModel> registerUser(String name, String number,
      String userType, String deviceId, String token, String status) async {
    try {
      Response response = await _dio.post(
        '${_url}${Constants.registerUser}',
        data: {
          "name": name,
          "phoneNumber": number,
          "userType": userType,
          "userStatus": status,
          "deviceData": deviceId,
          "fcmToken": token
        },
        options: options,
      );
      print("${response.data}");

      return RegisterUserModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RegisterUserModel.withError("Data not found / Connection issue");
    }
  }

  Future<RestaurantDetailsModel> getRestaurantDetails(String id) async {
    try {
      Response response =
          await _dio.get('${_url}${Constants.restaurantDetails}$id');
      print("${response.data}");

      return RestaurantDetailsModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RestaurantDetailsModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<MenuListModel> getMenuList(String id, String restId) async {
    try {
      print('${_url}${Constants.getFavMenu}');
      Response response = await _dio.post(
        '${_url}${Constants.getFavMenu}',
        data: {"userId": id, "restaurantId": restId},
        options: options,
      );
      print("get menu list response is ${response.data}");

      return MenuListModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MenuListModel.withError("Data not found / Connection issue");
    }
  }

  Future<AddFavoriteMenuModel> addFavMenu(
      String userId, String menuId, String restaurantId) async {
    print('user id : $userId');
    print('menu id : $menuId');
    print('restaurantId : $restaurantId');
    try {
      Response response = await _dio.post(
        '${_url}${Constants.addFavMenu}',
        data: {
          "userId": userId,
          "menuId": menuId,
          "restaurantId": restaurantId
        },
        options: options,
      );
      print("fav menu response : ${response.data}");

      return AddFavoriteMenuModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return AddFavoriteMenuModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<String> deleteFavMenu(String userId) async {
    try {
      Response response =
          await _dio.delete('${_url}${Constants.getFavMenu}$userId');
      print("${response.data}");
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'error';
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 'error';
    }
  }

  Future<String> addFavRestaurant(String userId, String restId) async {
    try {
      Response response = await _dio.post(
        '${_url}${Constants.addFavRestaurant}',
        data: {"userId": userId, "restaurantId": restId},
        options: options,
      );
      print("${response.data}");
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'error';
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 'error';
    }
  }

  Future<String> deleteFavRestaurant(String userId) async {
    try {
      Response response =
          await _dio.delete('${_url}${Constants.getFavRestaurant}$userId');
      print("${response.data}");
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'error';
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 'error';
    }
  }

  Future<GetNearByRestaurantModel> getNearByRestaurant(
      String userId, double lat, double lag) async {
    print('calling api : $lat and $lag');
    print('userId $userId');
    try {
      Response response = await _dio.post(
        '${_url}${Constants.restaurantNearBy}',
        data: {"userId": userId, "lat": lat, "lng": lag},
        options: options,
      );
      print("the near by rest reponse is : ${response.data}");

      return GetNearByRestaurantModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return GetNearByRestaurantModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<GetNearByRestaurantModel> getNearByRestaurantByPagination(
    String userId,
    double lat,
    double lag,
    int page,
    int size,
  ) async {
    print('calling api : $lat and $lag');
    try {
      Response response = await _dio.post(
        '${_url}${Constants.nearRestaurantsListByPagination}',
        data: {
          "userId": userId,
          "lat": lat,
          "lng": lag,
          "userStatus": "ACTIVEOPENED",
          "page": page,
          "size": size
        },
        options: options,
      );
      print("${response.data}");

      return GetNearByRestaurantModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return GetNearByRestaurantModel.withError(
        "Data not found / Connection issue",
      );
    }
  }

  Future<GetNearByRestaurantModel> getFavHotelList(String userId) async {
    try {
      Response response =
          await _dio.get('${_url}${Constants.getFavRestaurant}$userId');
      print("${response.data}");

      return GetNearByRestaurantModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return GetNearByRestaurantModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<GetFavMenuModel> getFavMenuList(
      String userId, String restaurantID) async {
    try {
      Response response = await _dio.post(
        '${_url}${Constants.getFavMenu}',
        data: {"userId": userId, "restaurantId": restaurantID},
        options: options,
      );
      print("getFavMenuList : ${response.data}");

      return GetFavMenuModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return GetFavMenuModel.withError("Data not found / Connection issue");
    }
  }

  Future<OrderCheckoutModel> createOrder(
      String restaurantId,
      String restaurantName,
      String customerId,
      List menuData,
      String orderType,
      String paymentType,
      String orderStatus,
      int totalAmount,
      String comments,
      String timeSlot,
      String transMode,
      double paidAmount,
      int usedCoins,
      double lat,
      double lng) async {
    print(
        'this is request data :{ restaurantId: $restaurantId, restaurantName: $restaurantName,"customerId": $customerId,"menus": $menuData'
        ',"orderType":$orderType,"paymentType": $paymentType,"orderStatus": $orderStatus,"totalAmount": $totalAmount'
        ',"comments": $comments,"timeSlot": $timeSlot,"transMode":$transMode, paid amount : $paidAmount');
    try {
      Response response = await _dio.post(
        '${_url}${Constants.createOrder}',
        data: {
          "restaurantId": restaurantId,
          "restaurantName": restaurantName,
          "customerId": customerId,
          "menus": menuData,
          "orderType": orderType,
          "paymentType": paymentType,
          "orderStatus": orderStatus,
          "totalAmount": totalAmount,
          "paidAmount": paidAmount,
          "usedCoins": usedCoins,
          "comments": comments,
          "timeSlot": timeSlot,
          "travelMode": transMode,
          "lat": lat,
          "lng": lng
        },
        options: options,
      );
      print("${response.data}");

      return OrderCheckoutModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return OrderCheckoutModel.withError("Data not found / Connection issue");
    }
  }

  Future<MyOrdersModel> getMyOrders(String userId) async {
    try {
      Response response = await _dio.get('${_url}${Constants.myOrders}$userId');
      print("${response.data}");

      return MyOrdersModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MyOrdersModel.withError("Data not found / Connection issue");
    }
  }

  Future<RestaurantByMenuTypeModel> getRestaurantDetailsByMenuType(
      String menuType) async {
    try {
      Response response = await _dio
          .get('${_url}${Constants.getRestaurantByMenuType}$menuType');
      print("${response.data}");

      return RestaurantByMenuTypeModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RestaurantByMenuTypeModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<WalletDetailsModel> getWalletDetails(String id) async {
    try {
      Response response = await _dio.get('${_url}${Constants.getMyWallet}$id');
      print("${response.data}");

      return WalletDetailsModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return WalletDetailsModel.withError("Data not found / Connection issue");
    }
  }

  Future<SaveIntroducerModel> saveIntroducers(String acceptorUuid,
      String introducerPhone, String acceptorDeviceId) async {
    try {
      Response response = await _dio.post(
        '${_url}${Constants.saveIntroducers}',
        data: {
          "acceptorId": acceptorUuid,
          "acceptorDevice": acceptorDeviceId,
          "introducerPhone": introducerPhone,
          "referenceType": "CUSTOMER"
        },
        options: options,
      );
      print("${response.data}");

      return SaveIntroducerModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return SaveIntroducerModel.withError("Data not found / Connection issue");
    }
  }

  Future<GetNearByRestaurantModel> getRestaurantOnway(
      String userId, String polylinePoints, double lat, double lng) async {
    print(
        'get roues request : "userId": $userId,"roadPolyline": $polylinePoints,'
        ' "originLat": $lat, "originLang": $lng, "mode": "DRIVE"');
    try {
      Response response = await _dio.post(
        '${_url}${Constants.restaurantOnway}',
        data: {
          "userId": userId,
          "roadPolyline": polylinePoints,
          "originLat": lat,
          "originLang": lng,
          "mode": "DRIVE"
        },
        options: options,
      );
      print("route response : ${response.data}");

      return GetNearByRestaurantModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return GetNearByRestaurantModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<UpdateOrderModel> updateOrderStatus(
      String orderId, String orderStatus) async {
    print('calling update order status');
    print('calling update order id : ${orderId} and status ${orderStatus}');
    try {
      Response response = await _dio.put(
        '${_url}${Constants.update_order_status}',
        data: {"orderId": orderId, "orderStatus": orderStatus},
        options: options,
      );
      print("${response.data}");

      return UpdateOrderModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return UpdateOrderModel.withError("Data not found / Connection issue");
    }
  }

  // Future<UpdateOrderModel> updateDevice(
  //     String orderId, String orderStatus) async {
  //   try {
  //     Response response =
  //         await _dio.put('${_url}${Constants.update_device}', data: {
  //       "userId": orderId,
  //       "deviceData": orderStatus,
  //       "fcmToken": orderStatus,
  //       "deviceUserType": "CUSTOMER"
  //     });
  //     print("${response.data}");
  //
  //     return UpdateOrderModel.fromJson(response.data);
  //   } catch (error, stacktrace) {
  //     print("Exception occured: $error stackTrace: $stacktrace");
  //     return UpdateOrderModel.withError("Data not found / Connection issue");
  //   }
  // }

  Future<RemoveFavRestaurantModel> removeFavRestaurant(
      String userId, String restaurantId) async {
    try {
      Response response = await _dio.delete(
        '${_url}${Constants.remove_fav_restaurant}',
        data: {
          "userId": userId,
          "restaurantId": restaurantId,
        },
        options: options,
      );
      print("${response.data}");

      return RemoveFavRestaurantModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RemoveFavRestaurantModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<RemoveFavRestaurantModel> removeFavMenu(
      String userId, String menuId) async {
    try {
      Response response = await _dio.delete(
        '${_url}${Constants.remove_fav_restaurant}',
        data: {
          "userId": userId,
          "menuId": menuId,
        },
        options: options,
      );
      print("${response.data}");

      return RemoveFavRestaurantModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RemoveFavRestaurantModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<PaymentDetailsModel> addPayDetails(
      String orderId,
      String receiverId,
      String senderId,
      String status,
      String transactionId,
      String orderNumber,
      String paymentId,
      double amount,
      double usedCoins,
      String data,
      double paidAmount,
      String paymentMode,
      String payerName,
      String payerMobile) async {
    try {
      Response response = await _dio.post(
        '${_url}${Constants.paymentDetails}',
        data: {
          "orderId": orderId,
          "receiverId": receiverId,
          "senderId": senderId,
          "status": status,
          "statusCode": "200",
          "transactionId": transactionId,
          "orderNumber": orderNumber,
          "paymentId": paymentId,
          "amount": amount,
          "usedCoins": usedCoins,
          "data": data,
          "paidAmount": paidAmount,
          "paymentMode": paymentMode,
          "payerName": payerName,
          "payerMobile": payerMobile
        },
        options: options,
      );
      print("${response.data}");

      return PaymentDetailsModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return PaymentDetailsModel.withError("Data not found / Connection issue");
    }
  }

  Future<VerifyOtpModel> updateDeviceData(
      String userId, String deviceData, String fcmToken) async {
    print("this is userId  $userId");
    print("this is deviceData  ${deviceData}");
    print("this is fcmToken  ${fcmToken}");

    try {
      Response response = await _dio.put(
        '${_url}${Constants.updateDevice}',
        data: {
          "userId": userId,
          "deviceData": deviceData,
          "fcmToken": fcmToken,
          "deviceUserType": "CUSTOMER"
        },
        options: options,
      );
      print("this is response in api provider ${response.data}");
      return VerifyOtpModel.fromJson(response.data);
    } catch (error, stacktrace) {
      return VerifyOtpModel.withError("Data not found / Connection issue");
    }
  }

  Future<Map<String, dynamic>> getDirections(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA&'
        'avoid=tolls|highways|ferries';
    print(' this is url: $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('this is directions response : ${response.body}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load directions');
    }
  }

  Future<void> computeRoutes() async {
    final String url =
        'https://routes.googleapis.com/directions/v2:computeRoutes?key=AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA';

    Map<String, dynamic> requestBody = {
      "origin": {
        "location": {
          "latLng": {"latitude": 12.9913243, "longitude": 77.7301459}
        }
      },
      "destination": {
        "location": {
          "latLng": {"latitude": 13.072170, "longitude": 77.792221}
        }
      },
      "travelMode": "DRIVE"
    };

    String jsonBody = json.encode(requestBody);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-FieldMask':
              'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('Error details: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<AcceptorsListModel> getAcceptors(String id) async {
    try {
      Response response = await _dio.get(
          '${_url}${Constants.getAcceptors}$id'); //here id is user / customer / owner id
      print("${response.data}");

      return AcceptorsListModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return AcceptorsListModel.withError("Data not found / Connection issue");
    }
  }

  Future<InitiatePaymentModel> initiatePayment(
      String name, String phone, String amount, String txnId) async {
    try {
      Response response = await _dio.post(
        '${_url}${Constants.initiate_payment}',
        data: {
          "name": name,
          "txnId": txnId,
          "phone": phone,
          "amount": double.parse(amount)
        },
        options: options,
      );
      print("${response.data}");

      return InitiatePaymentModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return InitiatePaymentModel.withError(
          "Data not found / Connection issue");
    }
  }

  Future<AppVersionModel> getAppVersion() async {
    try {
      Response response = await _dio.get(
          '${_url}${Constants.check_app_version}'); //here id is user / customer / owner id
      print("${response.data}");

      return AppVersionModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return AppVersionModel.withError("Data not found / Connection issue");
    }
  }

  Future<RemoveUserModel> removeUserData(String userId) async {
    try {
      Response response = await _dio.post(
        '${_url}${Constants.remove_user_data}',
        data: {"userId": userId},
        options: options,
      );
      print("${response.data}");

      return RemoveUserModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return RemoveUserModel.withError("Data not found / Connection issue");
    }
  }

  Future<ResaturantSearchModel> searchRestaurant(
      String querry, double lat, double lag, String userId) async {
    print(
        'this is search params : userId :$userId, lat : $lat, lng : $lag, letters : $querry');
    try {
      Response response = await _dio.post(
        '${_url}${Constants.restaurant_search}',
        data: {"userId": userId, "lat": lat, "lng": lag, "letters": querry},
        options: options,
      );
      // Response response = await _dio.get('${_url}${Constants.restaurant_search}$querry');
      print("Status Code  : ${response.statusCode}");
      print("${response.data}");

      return ResaturantSearchModel.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ResaturantSearchModel.withError(
          "Data not found / Connection issue");
    }
  }
}
