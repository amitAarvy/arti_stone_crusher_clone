import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage{
  final storage = const FlutterSecureStorage();


  Future<String?> getValue(String key)async{
    String? value = await storage.read(key: key);
    return value;
  }

  Future<bool> setValue(String key, String value)async{
    try{
      await storage.write(key: key, value: value);
      return true;
    }catch(e, s){
      return false;
    }
  }

  Future<bool> clearValue(String key)async{
    try{
      await storage.delete(key: key);
      return true;
    }catch(e, s){
      return false;
    }
  }

}