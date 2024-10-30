import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CreateOrderEvent extends Equatable {
  const CreateOrderEvent();
}

class OnPaymentClicked extends CreateOrderEvent {
  final String restaurantId;
  final String restaurantName;
  final String customerId;
  final List menuData;
  final String orderType;
  final String paymentType;
  final String orderStatus;
  final int totalAmount;
  final String comments;
  final String timeSlot;
  final String transMode;
  final double paidAmount;
  final int usedCoins;

  const OnPaymentClicked({required this.restaurantId,required this.restaurantName, required this.customerId,
  required this.menuData,required this.orderType,required this.paymentType,
  required this.orderStatus,required this.totalAmount,required this.comments,required this.timeSlot,
  required this.transMode,required this.paidAmount,required this.usedCoins});

  @override
  List<Object> get props => [restaurantId, customerId];
}

class OnAddTransactionData extends CreateOrderEvent {
  final String orderId;
  final String receiverId;
  final String senderId;
  final String status;
  final String transactionId;
  final String orderNumber;
  final String paymentId;
  final double amount;
  final double usedCoins;
  final String data;

  const OnAddTransactionData({required this.orderId,required this.receiverId, required this.senderId,
    required this.status,required this.transactionId,required this.orderNumber, required this.paymentId,
    required this.amount, required this.usedCoins, required this.data });

  @override
  List<Object> get props => [orderId, receiverId];
}

class OnGetRewardsDetails extends CreateOrderEvent {
  final String userId;

  const OnGetRewardsDetails({required this.userId});

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'OnButtonClicked { number: $userId }';
}

class InitiatePayment extends CreateOrderEvent {
  final String name;
  final String number;
  final String amount;
  final String txnId;

  const InitiatePayment({required this.name,required this.number, required this.amount, required this.txnId });

  @override
  List<Object> get props => [name, number,amount];
}
