import 'package:arti_stone_crusher/utils/api_services.dart';
import 'package:flutter/cupertino.dart';

import '../network/network_api_services.dart';


class InvoiceRepo{
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

  Future productListFetch(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.productList, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
  Future fetchMeasurement(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.measurementId, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
  Future fetchPrice(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.priceInvoice, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
  Future fetchParty(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.party, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future fetchVehicleList(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.vehicleList, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
  Future fetchCompanyList(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.companyList, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
  Future fetchPlantList(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.plantList, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future fetchSupplierList(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.supplier, data: data);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
  Future createInvoice(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.createInvoice, data: data,withFile: true);
      print('check api error is ${res}');
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future updateInvoice(Map<String, dynamic> data)async{
    try{
      var res = await _api.postRequest(ApiServices.updateInvoice, data: data,jsonType: true);
      return res;
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

}