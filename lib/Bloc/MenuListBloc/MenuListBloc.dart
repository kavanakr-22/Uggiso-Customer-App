import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/AddFavoriteMenuModel.dart';
import '../../Model/MenuListModel.dart';
import '../../Model/RemoveFavRestaurantModel.dart';
import '../../Network/NetworkError.dart';
import '../../Network/apiRepository.dart';
import 'MenuListEvent.dart';
import 'MenuListState.dart';

class MenuListBloc extends Bloc<MenuListEvent, MenuListState> {
  MenuListBloc() : super(FetchListState()){
    final ApiRepository _apiRepository = ApiRepository();
    AddFavoriteMenuModel? addFavoriteMenuModel;
    RemoveFavRestaurantModel? data;
    late MenuListModel menuListModel = MenuListModel();
    List<Payload> vegMenu = [];
    List<Payload> nonVegMenu = [];


    on<onInitialised>((event,emit)async{
      try{
        emit(FetchingState()) ;
        menuListModel = await _apiRepository.getMenuList(event.userId,event.restaurantId);
        if(menuListModel.statusCode == 200) {
          if(menuListModel.payload!=null && menuListModel.payload!.isNotEmpty){
            final List<Payload>? items = menuListModel.payload; // Extract the list from the response
            emit(FetchedListsState(items));
          }
          else{
            emit(ErrorState(menuListModel.message));
          }

        } else {
          emit(ErrorState(menuListModel.message));
        }
      }on NetworkError {
        emit(ErrorState('this is network error'));
      }
    });

    on<OnAddFavMenu>((event, emit) async {
      try {
        emit(FetchingState());
        print('this is userId : ${event.userId}');
        print('this is menu ID : ${event.menuId}');
        if (event.userId == null || event.menuId == null) {
          // Handle the case where userId or restaurantId is null
          print('this is userId : ${event.userId}');
          print('this is restaurant ID : ${event.menuId}');
          emit(ErrorState("userId or restaurantId is null"));
          return;
        }
        addFavoriteMenuModel = (await _apiRepository.addFavMenu(event.userId!, event.menuId!,event.restaurantId!));
        if (addFavoriteMenuModel?.statusCode!=200) {
          emit(ErrorState(addFavoriteMenuModel?.message));
        } else {
          emit(onFavMenuAddedState(addFavoriteMenuModel!));
        }
      } on NetworkError {
        print('this is network error');
      }
    });

    on<OnDeleteFavMenu>((event, emit) async {
      try {
        emit(FetchingState());
        print('this is userId : ${event.userId}');
        print('this is menu ID : ${event.menuId}');
        if (event.userId == null || event.menuId == null) {
          // Handle the case where userId or restaurantId is null
          print('this is userId : ${event.userId}');
          print('this is restaurant ID : ${event.menuId}');
          emit(ErrorState("userId or restaurantId is null"));
          return;
        }
        data = (await _apiRepository.removeFavMenu(event.userId!, event.menuId!));
        if (data?.statusCode!=200) {
          emit(ErrorState(data?.message));
        } else {
          emit(onDeleteMenuAddedState(data!));
        }
      } on NetworkError {
        print('this is network error');
      }
    });

  }

}
