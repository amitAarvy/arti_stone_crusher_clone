class AppException implements Exception{
  final String? _message;
  final String? _prefix;
  const AppException([this._message, this._prefix]);

  @override
  String toString(){
    return "$_prefix $_message";
  }
}

class FetchDataException extends AppException{
  const FetchDataException([String? message]) : super(message, "Fetch Data Failed");
}

class NoInternetException extends AppException{
  const NoInternetException([String? message]) : super(message, "No Internet");
}

class UnauthorizedException extends AppException{
  const UnauthorizedException([String? message]) : super(message, "Authorization Failed");
}
class RequestTimeoutException extends AppException{
  const RequestTimeoutException([String? message]) : super(message, "Request Time Out");
}