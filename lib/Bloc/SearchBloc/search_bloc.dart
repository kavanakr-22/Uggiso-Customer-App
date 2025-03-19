import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uggiso/Bloc/SearchBloc/search_event.dart';
import 'package:uggiso/Bloc/SearchBloc/search_state.dart';
import 'package:uggiso/Model/RestaurantSearchModel.dart';
import 'package:uggiso/Network/apiRepository.dart';

import '../../Network/NetworkError.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(InitialState()) {

    final ApiRepository _apiRepository = ApiRepository();
    late ResaturantSearchModel data;


    on<OnSearchInitiated>((event,emit) async{

      try{
        emit(LoadingState()) ;
        if(event.querry.isNotEmpty) {
          data =  await _apiRepository.searchRestaurant(event.querry);
          print('search response payload: ${data.payload?.restaurants}');

          if(data.statusCode == 200){
            emit(onLoadedState(data));
          }
          else{
            emit(ErrorState('${data.message}'));
          }


        }
        else{
          emit(ErrorState('Unable to fetch requested data. Please try again later.'));
        }

      } on NetworkError {
        print('this is network error');
      }
    });
  }

}