import 'package:equatable/equatable.dart';

part of 'signup_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class GetOtpResponse extends SignUpEvent {}