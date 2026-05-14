import 'dart:async';

import 'package:arti_stone_crusher/services/session_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ui/auth/login.dart';
import '../ui/home/home.dart';

class SplashServices{
  SessionController sessionController = SessionController();
  void isLogin(BuildContext context){
    sessionController.getUserDetails().then((bool value) {
      if(value){
        // context.read<ProfileBloc>().add(GetUserStatus());
        Timer(const Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
        },);
      }else{
        Timer(const Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Login()), (route) => false);
        },);
      }
    }).onError((error, stackTrace){
      Timer(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Login()), (route) => false);
      },);
    });
  }
}