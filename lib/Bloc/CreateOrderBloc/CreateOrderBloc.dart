import 'package:bloc/bloc.dart';
import 'package:uggiso/Bloc/CreateOrderBloc/CreateOrderEvent.dart';
import 'package:uggiso/Bloc/CreateOrderBloc/CreateOrderState.dart';
import 'package:uggiso/Model/InitiatePaymentModel.dart';
import 'package:uggiso/Model/OrderCheckoutModel.dart';
import 'package:uggiso/Model/PaymentDetailsModel.dart';
import 'package:uggiso/Model/WalletDetailsModel.dart';
import 'package:uggiso/Network/NetworkError.dart';
import 'package:uggiso/Network/apiRepository.dart';
class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  late OrderCheckoutModel data;
  late WalletDetailsModel walletData;
  late PaymentDetailsModel paymentData;
  late InitiatePaymentModel initiatePaymentData;
  CreateOrderBloc() : super(InitialState()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<OnPaymentClicked>((event, emit) async {
      try {
        emit(LoadingHotelState());
        data = await _apiRepository.createOrder(event.restaurantId,event.restaurantName, event.customerId,
            event.menuData,event.orderType,event.paymentType,event.orderStatus,event.totalAmount,
        event.comments,event.timeSlot,event.transMode,event.paidAmount,event.usedCoins);
        if(data.payload == null){

          emit(ErrorState(data.message.toString()));
        }
        else{
          emit(onLoadedHotelState(data));

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
            event.status,event.transactionId,event.orderNumber,event.paymentId);
        if(paymentData.payload == null){

          emit(ErrorState(paymentData.message.toString()));
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
          print('wallet details api response: ${data.payload}');
          emit(onCoinDetailsFetched(walletData));

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
          initiatePaymentData =  await _apiRepository.initiatePayment(event.name,event.number,event.amount);
          print('wallet details api response: ${initiatePaymentData.payload}');
          if(initiatePaymentData.statusCode==200){
            emit(onPaymentInitiated(initiatePaymentData));

          }
          else{
            emit(ErrorState(initiatePaymentData.message!));
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
