import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class InitialState extends ProfileState {}

class LoadingState extends ProfileState {}

class onLoadedState extends ProfileState {
  //  final WalletDetailsModel data;
  // onLoadedState(this.data);
}


class ErrorState extends ProfileState {
  final String? message;
  const ErrorState(this.message);
}