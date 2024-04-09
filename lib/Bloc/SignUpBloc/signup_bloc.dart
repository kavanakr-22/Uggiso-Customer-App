import 'package:bloc/bloc.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_event.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_state.dart';
import 'package:uggiso/Model/otpModel.dart';
import 'package:uggiso/Network/NetworkError.dart';
import 'package:uggiso/Network/apiRepository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(InitialState()){
    final ApiRepository _apiRepository = ApiRepository();

    on<OnButtonClicked>((event,emit) async{

    try{
    emit(LoadingState()) ;
    await _apiRepository.getOtp(event.number);
    emit(onLoadedState());

    } on NetworkError {
      print('this is network error');
    }
    });
  }

}
