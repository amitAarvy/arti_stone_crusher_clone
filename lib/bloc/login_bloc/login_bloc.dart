import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../services/session_controller.dart';
import '../../utils/enum.dart';
import '../../data/repo/login_repo.dart';
import 'login_event.dart';
import 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState>{
  final LoginRepo loginRepo;
  final SessionController _sessionController = SessionController();
  LoginBloc({required this.loginRepo}) : super(const LoginState()){
    on<EmailChange>(_emailChange);
    on<PasswordChange>(_passwordChange);
    on<LoginWithEmailPassword>(_loginWithEmailPassword);
  }

  void _emailChange(EmailChange event, Emitter<LoginState> emit){
    emit(state.copyWith(emailId: event.emailId));
  }

  void _passwordChange(PasswordChange event, Emitter<LoginState> emit){
    emit(state.copyWith(password: event.password));
  }
  void _loginWithEmailPassword(LoginWithEmailPassword event, Emitter<LoginState> emit)async
  {
    try{
      if(state.emailId.isEmpty) throw "Enter your email id";
      if(state.password.isEmpty) throw "Enter your password";
      Map<String, dynamic> data = {
        "username" : state.emailId,
        "password" : state.password,
      };
      emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await loginRepo.loginUser(data);
      print('api resoonse is ${res}');
      if(res['result']['success'].toString() == "1"){
        await _sessionController.saveUserInPreference(jsonEncode(res['result']));
        await _sessionController.getUserDetails();
        emit(state.copyWith(loginApiStatus: ApiStatus.success, successMsg: "Logged in successfully"));
      }else{
        throw res['result']['error_msg'];
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }finally{
      emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }
}

