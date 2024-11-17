import 'dart:convert';
import 'package:http/http.dart';
import 'package:uggiso/Model/AcceptorsListModel.dart';
import 'package:uggiso/Model/AddFavoriteMenuModel.dart';
import 'package:uggiso/Model/AppVersionModel.dart';
import 'package:uggiso/Model/GetRouteModel.dart';
import 'package:uggiso/Model/InitiatePaymentModel.dart';
import 'package:uggiso/Model/MenuListModel.dart';
import 'package:uggiso/Model/MyOrdersModel.dart';
import 'package:uggiso/Model/PaymentDetailsModel.dart';
import 'package:uggiso/Model/RegisterUserModel.dart';
import 'package:uggiso/Model/RestaurantDetailsModel.dart';
import 'package:uggiso/Model/UpdateOrderModel.dart';
import 'package:uggiso/Model/VerifyOtpModel.dart';
import 'package:uggiso/Model/otpModel.dart';
import 'package:uggiso/Network/apiProvider.dart';

import '../Model/GetFavMenuModel.dart';
import '../Model/GetFavRestaurantModel.dart';
import '../Model/GetNearByResaturantModel.dart';
import '../Model/OrderCheckoutModel.dart';
import '../Model/RemoveFavRestaurantModel.dart';
import '../Model/RestaurantByMenuTypeModel.dart';
import '../Model/SaveIntroducerModel.dart';
import '../Model/WalletDetailsModel.dart';

class ApiRepository {
  final _provider = ApiProvider();

  String userUrl = 'https://reqres.in/api/users?page=2';

  Future<OtpModel> getOtp(String number) {
    return _provider.getOtp(number);
  }

  Future<VerifyOtpModel> verifyOtp(String? number,String otp) {
    return _provider.verifyOtp(number,otp);
  }

  Future<RegisterUserModel> registerUser(String name,String number,String userType,String deviceId,String token, String status) {
    return _provider.registerUser(name,number,userType,deviceId,token,status);
  }

  Future<RestaurantDetailsModel> getResaturantDetails(String id) {
    return _provider.getRestaurantDetails(id);
  }

  Future<GetNearByRestaurantModel> getNearbyRestaurant(String userId,double lat, double lag, double distance,String mode) {
    return _provider.getNearByRestaurant(userId,lat,lag,distance,mode);
  }

  Future<MenuListModel> getMenuList(String? id,String? restId) {
    return _provider.getMenuList(id!,restId!);
  }

  Future<AddFavoriteMenuModel> addFavMenu(String userId, String menuId, String restaurantId) {
    return _provider.addFavMenu(userId,menuId,restaurantId);
  }

  Future<String> deleteFavMenu(String userId) {
    return _provider.deleteFavRestaurant(userId);
  }

  Future<String> addFavHotel(String userId, String restId) {
    return _provider.addFavRestaurant(userId,restId);
  }
  Future<String> deleteFavHotel(String userId) {
    return _provider.deleteFavRestaurant(userId);
  }

  Future<GetNearByRestaurantModel> getFavHotel(String restId) {
    return _provider.getFavHotelList(restId);
  }

  Future<GetFavMenuModel> getFavMenu(String menuId,String restaurantId) {
    return _provider.getFavMenuList(menuId,restaurantId);
  }

  Future<OrderCheckoutModel> createOrder(String restaurantId,String restaurantName,String customerId,
      List menuData,String orderType,String paymentType,
      String orderStatus,int totalAmount,String comments,
      String timeSlot,String transMode,
      double paidAmount, int usedCoins, double lat, double lng) {
    return _provider.createOrder(restaurantId,restaurantName,customerId,menuData,orderType,paymentType,orderStatus,
    totalAmount,comments,timeSlot,transMode,paidAmount,usedCoins,lat,lng);
  }

  Future<WalletDetailsModel> getWalletDetails(String userId) {
    return _provider.getWalletDetails(userId);
  }

  Future<SaveIntroducerModel> saveIntroducers(String acceptorUuid, String introducerPhone,String acceptorDeviceId) {
    return _provider.saveIntroducers(acceptorUuid,introducerPhone,acceptorDeviceId);
  }

  Future<MyOrdersModel> getMyOrders(String userId) {
    return _provider.getMyOrders(userId);
  }

  Future<GetRouteModel> getRestaurantOnway(String userId, String polylinePoints, double lat, double lng) {
    return _provider.getRestaurantOnway( userId,polylinePoints,lat,lng);
  }

  Future<UpdateOrderModel> updateOrderStatus(String orderId,String orderStatus) {
    return _provider.updateOrderStatus( orderId,orderStatus);
  }

  Future<RemoveFavRestaurantModel> removeFavRestaurant(String userId, String restaurantId) {
    return _provider.removeFavRestaurant( userId,restaurantId);
  }

  Future<RemoveFavRestaurantModel> removeFavMenu(String userId, String menuId) {
    return _provider.removeFavMenu( userId,menuId);
  }

  Future<PaymentDetailsModel> addPayDetails(String orderId, String receiverId,String senderId,
      String status,String transactionId, String orderNumber,String paymentId,double amount,
      double usedCoins,String data, double paidAmount, String paymentMode, String payerName, String payerMobile) {
    return _provider.addPayDetails( orderId,receiverId,senderId,status,transactionId,
      orderNumber,paymentId,amount,usedCoins,data,paidAmount,paymentMode,payerName,payerMobile);
  }

  Future<VerifyOtpModel> updateDeviceData(String userId, String deviceData,String fcmToken) {
    return _provider.updateDeviceData(userId,deviceData,fcmToken);
  }

  Future<AcceptorsListModel> getAcceptors(String id) {
    return _provider.getAcceptors(id);
  }

  Future<InitiatePaymentModel> initiatePayment(String name, String phone, String amount,String txnId) {
    return _provider.initiatePayment(name,phone,amount,txnId);
  }
  Future<AppVersionModel> getAppVersion() {
    return _provider.getAppVersion();
  }

}