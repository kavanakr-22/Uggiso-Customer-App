import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class OnSearchInitiated extends SearchEvent {
  final String querry;

  const OnSearchInitiated({required this.querry});

  @override
  List<Object> get props => [querry];

  @override
  String toString() => 'OnButtonClicked { number: $querry }';
}