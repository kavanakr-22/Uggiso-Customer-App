import 'package:equatable/equatable.dart';
import 'package:uggiso/Model/RestaurantSearchModel.dart';
import 'package:uggiso/Model/WalletDetailsModel.dart';
import 'package:uggiso/Model/otpModel.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class InitialState extends SearchState {}

class LoadingState extends SearchState {}

class onLoadedState extends SearchState {
  final ResaturantSearchModel data;
  onLoadedState(this.data);
}


class ErrorState extends SearchState {
  final String? message;
  const ErrorState(this.message);
}