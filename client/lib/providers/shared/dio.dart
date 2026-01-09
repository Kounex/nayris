import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../types/exceptions/api.dart';

final dioProvider = Provider((ref) {
  const serverURL = String.fromEnvironment('CUSTOM_SERVER_URL');

  final dio = Dio(
    BaseOptions(
      baseUrl: serverURL.isEmpty
          ? Uri(
              scheme: Uri.base.scheme,
              host: Uri.base.host,
              port: Uri.base.hasPort ? 4444 : null,
              path: '/api/v1',
            ).toString()
          : serverURL,
      // !Uri.base.hasPort
      //     ? 'https://nayris.kounex.com/api'
      //     : 'http://localhost:4444',
      validateStatus: (_) => true,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        if (response.headers['content-type']!.contains('json') &&
            response.data?['error'] != null) {
          throw APIException(jsonError: response.data);
        }
        return handler.next(response);
      },
    ),
  );

  return dio;
});
