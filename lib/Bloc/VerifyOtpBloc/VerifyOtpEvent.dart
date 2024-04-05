import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();
}

class LoadVerifyOtpEvent extends VerifyOtpEvent {
  @override
  List<Object?> get props => [];
}