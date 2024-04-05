import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uggiso/Model/otpModel.dart';

@immutable
abstract class VerifyOtpState extends Equatable {}

class VerifyOtpLoadingState extends VerifyOtpState {
  @override
  List<Object?> get props => [];
}

class VerifyOtpLoadedState extends VerifyOtpState {
  final List<OtpModel> users;
  VerifyOtpLoadedState(this.users);
  @override
  List<Object?> get props => [users];
}

class VerifyOtpErrorState extends VerifyOtpState {
  final String error;
  VerifyOtpErrorState(this.error);
  @override
  List<Object?> get props => [error];
}