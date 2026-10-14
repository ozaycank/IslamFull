import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:injectable/injectable.dart';
import '../config/environment_config.dart';
import '../constants/app_constants.dart';
import '../logging/logger_service.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;
  final LoggerService _loggerService;

  DioClient(this._loggerService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvironmentConfig.apiBaseUrl,
        connectTimeout:
            const Duration(milliseconds: EnvironmentConfig.connectTimeout),
        receiveTimeout:
            const Duration(milliseconds: EnvironmentConfig.receiveTimeout),
        headers: {
          'Content-Type': AppConstants.contentTypeJson,
          'Accept': AppConstants.contentTypeJson,
        },
      ),
    );

    if (kDebugMode && EnvironmentConfig.isDevelopment) {
      _dio.interceptors.add(
        LogInterceptor(
          // Never log payloads or headers, which may hold sensitive data.
          requestBody: false,
          responseBody: false,
          requestHeader: false,
          responseHeader: false,
          logPrint: (object) => _loggerService.debug('[DIO] $object'),
        ),
      );
    }
  }

  Dio get dio => _dio;
}
