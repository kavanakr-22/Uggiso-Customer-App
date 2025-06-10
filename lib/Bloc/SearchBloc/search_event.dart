import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class OnSearchInitiated extends SearchEvent {
  final String querry;
  final double lat;
  final double lag;
  final String userId;

  const OnSearchInitiated({required this.querry, required this.lat, required this.lag, required this.userId});

  @override
  List<Object> get props => [querry];

  @override
  String toString() => 'OnButtonClicked { number: $querry }';
}