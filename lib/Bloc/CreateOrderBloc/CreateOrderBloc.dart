import 'package:bloc/bloc.dart';
import 'package:uggiso/Bloc/CreateOrderBloc/CreateOrderEvent.dart';
import 'package:uggiso/Bloc/CreateOrderBloc/CreateOrderState.dart';
import 'package:uggiso/Model/InitiatePaymentModel.dart';
import 'package:uggiso/Model/OrderCheckoutModel.dart';
import 'package:uggiso/Model/PaymentDetailsModel.dart';
import 'package:uggiso/Model/WalletDetailsModel.dart';
import 'package:uggiso/Network/NetworkError.dart';
import 'package:uggiso/Network/apiRepository.dart';
import 'package:uuid/uuid.dart';
class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
   OrderCheckoutModel? data;
   WalletDetailsModel? walletData;
   PaymentDetailsModel? paymentData;
   InitiatePaymentModel? initiatePaymentData;
  CreateOrderBloc() : super(InitialState()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<OnPaymentClicked>((event, emit) async {
      try {
        emit(LoadingHotelState());
        data = await _apiRepository.createOrder(event.restaurantId,event.restaurantName, event.customerId,
            event.menuData,event.orderType,event.paymentType,event.orderStatus,event.totalAmount,
        event.comments,event.timeSlot,event.transMode,event.paidAmount,event.usedCoins,event.lat,event.lng);
        if(data!.statusCode==200 || data!.statusCode == 201){
          emit(onLoadedHotelState(data!));
        }
        else{
          emit(ErrorState(data!.message.toString()));

        }

      } on NetworkError {
        print('this is network error');
      }
    }
    );

    on<OnAddTransactionData>((event, emit) async {
      try {
        emit(LoadPaymentState());
        paymentData = await _apiRepository.addPayDetails(event.orderId,event.receiverId, event.senderId,
            event.status,event.transactionId,event.orderNumber,event.paymentId, event.amount,
            event.usedCoins,event.data, event.paidAmount,event.paymentMode, event.payerName,event.payerMobile);
        if(paymentData!.payload == null){

          emit(ErrorState(paymentData!.message.toString()));
        }
        else{
          emit(PaymentStateLoaded());
        }

      } on NetworkError {
        print('this is network error');
      }
    }
    );

    on<OnGetRewardsDetails>((event,emit) async{

      try{
        emit(FetchingCoinsDetails()) ;
        if(event.userId.isNotEmpty) {
          //String name,String number,String userType,String deviceId,String token
          walletData =  await _apiRepository.getWalletDetails(event.userId);
          print('wallet details api response: ${walletData!.payload}');
          emit(onCoinDetailsFetched(walletData!));

        }
        else{
          emit(ErrorState('Enter Valid Credentials'));
        }

      } on NetworkError {
        print('this is network error');
      }
    });

    on<InitiatePayment>((event,emit) async{

      try{
        emit(InitiatePaymentMode()) ;
        if(event.number.isNotEmpty) {
          //String name,String number,String userType,String deviceId,String token
          print('this is initiate payment request : ${event.name.trim().split(' ').last}, ${event.number}, ${event.amount},txn Id : ${event.txnId}');
          initiatePaymentData =  await _apiRepository.initiatePayment(event.name.trim().split(' ').last,event.number,event.amount,event.txnId);
          print('wallet details api response: ${initiatePaymentData!.payload}');
          if(initiatePaymentData!.statusCode==200){
            emit(onPaymentInitiated(initiatePaymentData!));

          }
          else{
            emit(InitiatePaymentFailed(initiatePaymentData!.message!));
          }
        }
        else{
          emit(ErrorState('Enter Valid Credentials'));
        }

      } on NetworkError {
        print('this is network error');
      }
    });
  }

}

String generateUUID() {
  var uuid = Uuid();
  // Generate a v4 (random) UUID
  String uniqueID = uuid.v4();
  print('Generated UUID : $uniqueID');
  return uniqueID;
}
