import 'package:bloc/bloc.dart';
import 'package:uggiso/Bloc/HomeBloc/HomeEvent.dart';
import 'package:uggiso/Bloc/HomeBloc/HomeState.dart';
import 'package:uggiso/Model/GetRouteModel.dart';
import 'package:uggiso/Model/RemoveFavRestaurantModel.dart';
import 'package:uggiso/Network/NetworkError.dart';
import 'package:uggiso/Network/apiRepository.dart';

import '../../Model/GetNearByResaturantModel.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  GetNearByRestaurantModel? data;
  RemoveFavRestaurantModel? delResult;
  GetNearByRestaurantModel? getRoutes;
  String? res;

  HomeBloc() : super(InitialState()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<OnInitilised>((event, emit) async {
      try {
        emit(LoadingHotelState());
        data = await _apiRepository.getNearbyRestaurant(
            event.userId, event.lat, event.lag, event.distance, event.mode);
        if (data!.statusCode != 200) {
          emit(ErrorState(data!.message.toString()));
        } else {
          emit(onLoadedHotelState(data!));
        }
      } on NetworkError {
        print('this is network error');
      }
    });

    on<OnUpdateFavOrder>((event, emit) async {
      try {
        emit(LoadingHotelState());
        data = await _apiRepository.getNearbyRestaurant(
            event.userId, event.lat, event.lag, event.distance, event.mode);
        if (data!.payload == null) {
          emit(ErrorState(data!.message.toString()));
        } else {
          emit(onLoadedHotelState(data!));
        }
      } on NetworkError {
        print('this is network error');
      }
    });

    on<OnAddFavRestaurant>((event, emit) async {
      try {
        emit(LoadingHotelState());
        print('this is userId : ${event.userId}');
        print('this is restaurant ID : ${event.restaurantId}');
        if (event.userId == null || event.restaurantId == null) {
          // Handle the case where userId or restaurantId is null
          print('this is userId : ${event.userId}');
          print('this is restaurant ID : ${event.restaurantId}');
          emit(ErrorState("userId or restaurantId is null"));
          return;
        }
        res = await _apiRepository.addFavHotel(
            event.userId!, event.restaurantId!);
        if (res == 'error') {
          emit(ErrorState(data!.message.toString()));
        } else {
          emit(onFavHotelAddedState(res!));
        }
      } on NetworkError {
        print('this is network error');
      }
    });

    on<OnDeleteFavRestaurant>((event, emit) async {
      try {
        emit(LoadingHotelState());
        print('this is userId : ${event.userId}');
        if (event.userId == null) {
          // Handle the case where userId or restaurantId is null
          print('this is userId : ${event.userId}');
          emit(ErrorState("userId or restaurantId is null"));
          return;
        }
        delResult = await _apiRepository.removeFavRestaurant(
            event.userId!, event.restaurantId!);
        if (delResult?.statusCode != 200) {
          emit(ErrorState(data!.message.toString()));
        } else {
          print('deleted success');
          emit(onFavHotelDeleteState(delResult!));
        }
      } on NetworkError {
        print('this is network error');
      }
    });

    on<OnGetRestaurantByRoute>((event, emit) async {
      try {
        emit(LoadingHotelState());
        print('this is userId : ${event.userId}');
        if (event.userId == null) {
          // Handle the case where userId or restaurantId is null
          print('this is userId : ${event.userId}');
          emit(ErrorState("userId or restaurantId is null"));
          return;
        }
        getRoutes = await _apiRepository.getRestaurantOnway(event.userId!,
            event.polylinePoints!, event.originLat, event.originLng);
        if (getRoutes?.statusCode == 200) {
          emit(RestaurantsLocationFound(getRoutes!));
        }
        if (getRoutes?.statusCode != 200) {
          emit(ErrorState(getRoutes!.message.toString()));
        } else {
          print('deleted success');
          // emit(onFavHotelDeleteState(getRoutes!));
        }
      } on NetworkError {
        print('this is network error');
      }
    });
    on<OnFetchMoreRestaurants>((event, emit) async {
      try {
        emit(FetchingMoreState());

        final paginatedResult =
            await _apiRepository.nearRestaurantsListByPagination(
          event.userId,
          event.lat,
          event.lag,
          event.distance,
          event.mode,
          event.page,
          event.size,
        );

        if (paginatedResult.statusCode != 200 ||
            paginatedResult.payload == null) {
          emit(PaginationErrorState(paginatedResult.message ?? "Error"));
          return;
        }

        final newList = paginatedResult.payload!;
        final oldList = data?.payload ?? [];

        final combinedList = [...oldList, ...newList];

        data = data?.copyWith(payload: combinedList) ?? paginatedResult;

        final hasMore = newList.length == event.size;
        emit(FetchedMoreState(combinedList, hasMore));
      } catch (e) {
        emit(PaginationErrorState("Failed to fetch more data"));
      }
    });
  }
}
