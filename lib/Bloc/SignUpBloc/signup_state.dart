import 'package:equatable/equatable.dart';
import 'package:uggiso/Model/otpModel.dart';

part of 'covid_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class InitialState extends SignUpState {}

class LoadingState extends SignUpState {}

class onLoadedState extends SignUpState {
  final OtpModel otpModel;
  const onLoadedState(this.otpModel);
}

class ErrorState extends SignUpState {
  final String? message;
  const ErrorState(this.message);
}