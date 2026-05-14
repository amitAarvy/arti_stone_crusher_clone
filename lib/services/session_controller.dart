import 'dart:convert';
import 'local_storage.dart';

class SessionController{

  static final SessionController _session = SessionController._internal();
  LocalStorage localStorage = LocalStorage();

  // LoginData userData = LoginData();
  bool isLogin = false;
  bool isPaid = false;

  SessionController._internal();

  factory SessionController(){
    return _session;
  }

  Future<bool> saveUserInPreference(String user)async{
    return await localStorage.setValue("loginData", user);
  }


  Future<bool> getUserDetails()async{
    String? data = await localStorage.getValue("loginData");
    if(data != null){
      var userDetail = jsonDecode(data);
      isLogin = true;
      return true;
    }else{
      isLogin = false;
      return false;
    }
  }

  Future<bool> removeUserFromPreference()async{
    isLogin = false;
    // userData = LoginData();
    isPaid = false;
    return await localStorage.clearValue("loginData");
  }

  // Future updatePhoto(String profilePhoto)async{
  //   userData = userData.copyWith(photo1: profilePhoto);
  //   await localStorage.setValue("loginData", jsonEncode(userData.toJson()));
  // }
  //
  // Future updateUserStatus({required String status, required bool paidStatus, required String paymentPlan})async{
  //   userData = userData.copyWith(status: status, paidStatus: paidStatus, paymentPlan: paymentPlan);
  //   isPaid = paidStatus;
  //   await localStorage.setValue("loginData", jsonEncode(userData.toJson()));
  // }

}