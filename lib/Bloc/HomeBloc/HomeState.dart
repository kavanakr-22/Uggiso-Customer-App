import 'package:equatable/equatable.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';
import 'package:uggiso/Model/GetRouteModel.dart';
import 'package:uggiso/Model/RemoveFavRestaurantModel.dart';
import 'package:uggiso/Model/otpModel.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart' as near;
import 'package:uggiso/Model/GetRouteModel.dart' as route;

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class InitialState extends HomeState {}

class LoadingHotelState extends HomeState {}

class onLoadedHotelState extends HomeState {
  final GetNearByRestaurantModel data;
  onLoadedHotelState(this.data);
}

class onFavHotelAddedState extends HomeState {
  final String result;
  onFavHotelAddedState(this.result);
}

class onFavHotelDeleteState extends HomeState {
  final RemoveFavRestaurantModel result;
  onFavHotelDeleteState(this.result);
}

class RestaurantsLocationFound extends HomeState {
  final GetNearByRestaurantModel result;
  RestaurantsLocationFound(this.result);
}

class ErrorState extends HomeState {
  final String message;
  ErrorState(this.message);
}

class FetchingMoreState extends HomeState {}

class FetchedMoreState extends HomeState {
  final List<near.Payload> updatedRestaurants;
  final bool hasMore;

  FetchedMoreState(this.updatedRestaurants, this.hasMore);
}

class PaginationErrorState extends HomeState {
  final String message;
  PaginationErrorState(this.message);
}
