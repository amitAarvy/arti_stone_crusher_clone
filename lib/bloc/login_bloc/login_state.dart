// part of 'challan_bloc.dart';


import 'package:equatable/equatable.dart';

import '../../utils/enum.dart';

class LoginState extends Equatable{
  final String emailId;
  final String password;
  final ApiStatus loginApiStatus;

  final String successMsg;
  final String error;

  const LoginState({
    this.emailId='',
    this.password='',
    this.loginApiStatus = ApiStatus.initial,
    this.successMsg = '',
    this.error = '',
  });

  LoginState backToInitial(){
    return const LoginState(
      emailId: '',
      password: '',
      loginApiStatus: ApiStatus.initial,
      successMsg: '',
      error: '',
    );
  }

  LoginState copyWith({
    String? emailId,
    String? password,

    dynamic advertiseImage,
    ApiStatus? loginApiStatus,
    String? successMsg,
    String? error,
  }){
    return LoginState(
      emailId: emailId ??this.emailId,
      password: password ??this.password,

      loginApiStatus: loginApiStatus ?? this.loginApiStatus,
      successMsg: successMsg ?? this.successMsg,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
   emailId,
    password,
    loginApiStatus,
    successMsg,
    error,
  ];
}