import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class OnInitilised extends HomeEvent {
  final double lat;
  final double lag;
  final double distance;
  final String userId;
  final String mode;

  const OnInitilised({required this.userId,required this.lat,required this.lag,required this.distance,required this.mode});
  @override
  List<Object> get props => [lat,lag];
}
class OnFetchMoreRestaurants extends HomeEvent {
  final String userId;
  final double lat;
  final double lag;
  final double distance;
  final String mode;
  final int page;
  final int size;

  OnFetchMoreRestaurants({
    required this.userId,
    required this.lat,
    required this.lag,
    required this.distance,
    required this.mode,
    required this.page,
    required this.size,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}


class OnUpdateFavOrder extends HomeEvent {
  final double lat;
  final double lag;
  final double distance;
  final String userId;
  final String mode;

  const OnUpdateFavOrder({required this.userId,required this.lat,required this.lag,required this.distance,required this.mode});
  @override
  List<Object> get props => [lat,lag];

}

class OnAddFavRestaurant extends HomeEvent{
  final String? userId;
  final String? restaurantId;


  const OnAddFavRestaurant({required this.userId,required this.restaurantId});

  @override
  List<Object> get props => [userId!,restaurantId!];
}

class OnDeleteFavRestaurant extends HomeEvent{
  final String? userId;
  final String? restaurantId;


  const OnDeleteFavRestaurant({required this.userId, required this.restaurantId});

  @override
  List<Object> get props => [userId!];
}

class OnGetRestaurantByRoute extends HomeEvent{
  final String? userId;
  final String? polylinePoints;
  final double originLat;
  final double originLng;


  const OnGetRestaurantByRoute({required this.userId, required this.polylinePoints, required this.originLat, required this.originLng});

  @override
  List<Object> get props => [userId!];
}
