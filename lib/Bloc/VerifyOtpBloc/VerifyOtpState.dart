import 'package:equatable/equatable.dart';
import 'package:uggiso/Model/otpModel.dart';

import '../../Model/VerifyOtpModel.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object?> get props => [];
}

class InitialState extends VerifyOtpState {}

class LoadingState extends VerifyOtpState {}

class onLoadedState extends VerifyOtpState {}

class userAlreadyRegistered extends VerifyOtpState {
  final VerifyOtpModel? data;
  const userAlreadyRegistered(this.data);
}
class deviceDataUpdated extends VerifyOtpState {}

class onResendOTPSuccessState extends VerifyOtpState {}

class ErrorState extends VerifyOtpState {
  final String? message;
  const ErrorState(this.message);
}

class onUserRegisteredState extends VerifyOtpState {
  final String? id;
  final String? name;
  final String? restId;
  const onUserRegisteredState(this.id,this.name,this.restId);
}