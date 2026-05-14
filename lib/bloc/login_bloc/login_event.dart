// part of 'advertise_bloc.dart';

import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable{
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class EmailChange extends LoginEvent{
  final String emailId;
  const EmailChange({required this.emailId});

  @override
  List<Object> get props => [emailId];
}

class PasswordChange extends LoginEvent{
  final String password;
  const PasswordChange({required this.password});

  @override
  List<Object> get props => [password];
}

class LoginWithEmailPassword extends LoginEvent{}


class SubmitAdvertiseData extends LoginEvent{}