import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileEvent.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileState.dart';
import 'package:uggiso/Model/RestaurantDetailsModel.dart';
import 'package:uggiso/Model/WalletDetailsModel.dart';
import 'package:uggiso/Network/apiRepository.dart';

import '../../Model/AcceptorsListModel.dart';
import '../../Model/remove_user_model.dart';
import '../../Network/NetworkError.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(InitialState()) {

    final ApiRepository _apiRepository = ApiRepository();
    late WalletDetailsModel data;
    AcceptorsListModel acceptorsData = AcceptorsListModel();
    RemoveUserModel removeUserData = RemoveUserModel();


    on<OnGetReferralHistory>((event,emit) async{

      try{
        emit(LoadingState()) ;
        if(event.userId.isNotEmpty) {
          //String name,String number,String userType,String deviceId,String token
          data =  await _apiRepository.getWalletDetails(event.userId);
          print('wallet details api response: ${data.payload}');
          emit(onLoadedState());

        }
        else{
          emit(ErrorState('Enter Valid Credentials'));
        }

      } on NetworkError {
        print('this is network error');
      }
    });

    on<OnGetAcceptors>((event,emit) async{

      try{
        emit(LoadingState()) ;
        if(event.userId.isNotEmpty) {
          //String name,String number,String userType,String deviceId,String token
          acceptorsData =  await _apiRepository.getAcceptors(event.userId);
          if(acceptorsData.statusCode ==200){
            emit(onAcceptorsDataFetched(acceptorsData));
          }
          else{
            emit(ErrorState(acceptorsData.message));
          }
        }
        else{
          emit(ErrorState('Enter Valid Credentials'));
        }

      } on NetworkError {
        print('this is network error');
      }
    });

    on<OnDeleteUserData>((event,emit) async{

      try{
        emit(LoadingState()) ;
        if(event.userId.isNotEmpty) {
          //String name,String number,String userType,String deviceId,String token
          removeUserData =  await _apiRepository.removeUserData(event.userId);
          if(removeUserData.statusCode ==200){
            emit(onUserDataRemovedSuccess(removeUserData));
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
          }
          else{
            emit(ErrorState(removeUserData.message));
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