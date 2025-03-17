import 'package:equatable/equatable.dart';
import 'package:uggiso/Model/AcceptorsListModel.dart';
import 'package:uggiso/Model/RestaurantDetailsModel.dart';
import 'package:uggiso/Model/remove_user_model.dart';

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

class onAcceptorsDataFetched extends ProfileState {
   final AcceptorsListModel data;
  onAcceptorsDataFetched(this.data);
}

class onUserDataRemovedSuccess extends ProfileState {
  final RemoveUserModel data;
  onUserDataRemovedSuccess(this.data);
}
class ErrorState extends ProfileState {
  final String? message;
  const ErrorState(this.message);
}