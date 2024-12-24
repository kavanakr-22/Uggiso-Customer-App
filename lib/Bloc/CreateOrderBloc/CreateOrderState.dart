import 'package:equatable/equatable.dart';
import 'package:uggiso/Model/InitiatePaymentModel.dart';
import 'package:uggiso/Model/OrderCheckoutModel.dart';
import 'package:uggiso/Model/WalletDetailsModel.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object?> get props => [];
}

class InitialState extends CreateOrderState {}

class LoadingHotelState extends CreateOrderState {}

class LoadPaymentState extends CreateOrderState {}

class PaymentStateLoaded extends CreateOrderState {}

class FetchingCoinsDetails extends CreateOrderState {}

class InitiatePaymentMode extends CreateOrderState {}


class onLoadedHotelState extends CreateOrderState {
  final OrderCheckoutModel data;
  onLoadedHotelState(this.data);
}

class onCoinDetailsFetched extends CreateOrderState {
  final WalletDetailsModel data;
  onCoinDetailsFetched(this.data);
}

class onPaymentInitiated extends CreateOrderState {
  final InitiatePaymentModel paymentData;
  onPaymentInitiated(this.paymentData);
}

class ErrorState extends CreateOrderState {
  final String message;
  ErrorState(this.message);
}
class InitiatePaymentFailed extends CreateOrderState {
  final String message;
  InitiatePaymentFailed(this.message);
}