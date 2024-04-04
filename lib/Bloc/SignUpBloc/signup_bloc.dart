import 'package:bloc/bloc.dart';
import 'package:uggiso/Network/apiRepository.dart';

part 'signup_event.dart.dart';
part 'signup_state.dart.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(InitialState()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<GetOtpResponse>((event, emit) async {
      try {
        emit(LoadingState());
        final mList = await _apiRepository.fetchCovidList();
        emit(onLoadedState(mList));
        if (mList.error != null) {
          emit(ErrorState(mList.error));
        }
      } on NetworkError {
        emit(ErrorState("Failed to fetch data. is your device online?"));
      }
    });
  }
}