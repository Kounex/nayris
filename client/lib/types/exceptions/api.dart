import 'package:dio/dio.dart';

class APIException implements Exception {
  APIError? error;
  String? customError;

  APIException({APIError? error, Map<String, dynamic>? jsonError})
      : error = error ??
            (jsonError?['error'] is int
                ? APIError.values[jsonError!['error']]
                : null),
        customError =
            jsonError?['error'] is String ? jsonError!['error'] : null;
}

extension ExceptionsFunctions on Object {
  bool isError(APIError error) =>
      this is APIException && (this as APIException).error == error;

  APIException? get api =>

      /// Was used before transferring the api error check into a dio
      /// interceptor which will always return a [DioError] as the wrapper.
      /// Therefore currently an [APIException] can only occur inside
      /// a [DioError] and we don't need to check the top level. Might need
      /// to add this if we set this exception somewhere manually as a top
      /// level exception
      ///
      // this is APIException
      //     ? this as APIException
      //     :
      this is DioError && (this as DioError).error is APIException
          ? (this as DioError).error as APIException
          : null;

  String? get apiError => this.api?.error?.text ?? this.api?.customError;
}

enum APIError {
  emptySearch,
  noResults,
}

extension APIErrorFunctions on APIError {
  String get text =>
      {
        APIError.emptySearch:
            'Your search query appears to be empty! Check your input - it should either be a full fledged Youtube URL or the last part containing watch...',
        APIError.noResults:
            'Nothing found for the given search query - check your input or try another one!',
      }[this] ??
      'Unknown error!';
}
