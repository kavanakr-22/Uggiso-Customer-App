import 'package:bloc/bloc.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_event.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_state.dart';
import 'package:uggiso/Model/otpModel.dart';
import 'package:uggiso/Network/NetworkError.dart';
import 'package:uggiso/Network/apiRepository.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(InitialState()){
    final ApiRepository _apiRepository = ApiRepository();

    on<OnButtonClicked>((event,emit) async{

    try{
    emit(LoadingState()) ;
    if(event.number.isNotEmpty && event.number.length == 10) {
      var res = await _apiRepository.getOtp(event.number);
      if(res.statusCode==200){
        emit(onLoadedState());

      }
      else{
        emit(ErrorState());
      }
    }
    else{
      print('this is error');
      emit(ErrorState());
    }

    } on NetworkError {
      print('this is network error');
    }
    });
  }

}
