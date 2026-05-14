import 'package:arti_stone_crusher/utils/api_services.dart';
import 'package:flutter/cupertino.dart';

import '../network/network_api_services.dart';


class LoginRepo{
  final NetworkApiServices _api = NetworkApiServices();

  Future fetchReligionData()async{
    try{
      var res = await _api.postRequest("religion_list_api.php", data: {
        // "matri_id" : SessionController().userData.matriId,
      });
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future loginUser(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.login, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }



}