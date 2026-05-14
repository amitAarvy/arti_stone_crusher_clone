import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'api_services.dart';
import 'app_exception.dart';

class NetworkApiServices extends ApiServices{
  static const String baseUrl = "https://www.artistonecrusher.com/";
  static const String host = '${baseUrl}webs_api/';
  Dio dio = Dio();

  @override
  Future getRequest(String url) async{
    debugPrint(baseUrl + url);
    try{
      var res = await dio.get(host+url).timeout(const Duration(seconds: 60));
      return returnResponse(res);
    }on SocketException{
      throw const NoInternetException();
    } on TimeoutException{
      throw const RequestTimeoutException();
    }
  }

  @override
  Future postRequest(String url, {Map<String, dynamic> data = const {}, bool withFile = false,bool jsonType = false}) async{
    debugPrint(host + url);
    debugPrint(data.toString());
    try{
      var res = await dio.post(
          host+url,
          options: Options(
              contentType: jsonType ? Headers.jsonContentType : Headers.formUrlEncodedContentType
          ),
          data: withFile ? FormData.fromMap(data) : data
      ).timeout(const Duration(seconds: 60));
      debugPrint('check api response is ${res.statusCode}');

      return returnResponse(res);
    }on SocketException{
      throw const NoInternetException();
    } on TimeoutException{
      throw const RequestTimeoutException();
    }
  }

  dynamic returnResponse(Response<dynamic> response){
    switch(response.statusCode){
      case 200 :
        return response.data;
      case 201 :
        return response.data;
      case 400 :
        return response.data;
      case 401 :
        return const UnauthorizedException();
      case 500 :
        return const FetchDataException();
      default :
        return const RequestTimeoutException();
    }
  }
}