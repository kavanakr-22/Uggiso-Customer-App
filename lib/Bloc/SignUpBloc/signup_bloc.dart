import 'package:bloc/bloc.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_event.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_state.dart';
import 'package:uggiso/Network/apiRepository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(InitialState());
  final ApiRepository _apiRepository = ApiRepository();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event
  ) async* {
    if (event is OnButtonClicked) {
      yield LoadingState();
      await _apiRepository.getOtp(event.number);
      yield onLoadedState();
    }
  }
}
