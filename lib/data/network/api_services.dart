abstract class ApiServices{

  Future<dynamic> getRequest(String url);

  Future<dynamic> postRequest(String url, {Map<String, dynamic> data = const {}});

}