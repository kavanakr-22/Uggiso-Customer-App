import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class OnGetReferralHistory extends ProfileEvent {
  final String userId;

  const OnGetReferralHistory({required this.userId});

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'OnButtonClicked { number: $userId }';
}

class OnGetAcceptors extends ProfileEvent {
  final String userId;

  const OnGetAcceptors({required this.userId});

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'OnButtonClicked { number: $userId }';
}

class OnDeleteUserData extends ProfileEvent {
  final String userId;

  const OnDeleteUserData({required this.userId});

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'OnButtonClicked { number: $userId }';
}