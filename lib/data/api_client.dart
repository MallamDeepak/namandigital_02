import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../core/error_handling.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.requestTimeout,
      receiveTimeout: AppConstants.requestTimeout,
      sendTimeout: AppConstants.requestTimeout,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'NewsReaderApp/1.0',
      },
    ));

    _setupInterceptors();
  }

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add API key to all requests
          options.queryParameters['apiKey'] = AppConstants.apiKey;
          
          // Log request details in debug mode
          print('REQUEST: ${options.method} ${options.uri}');
          if (options.data != null) {
            print('REQUEST DATA: ${options.data}');
          }
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response details in debug mode
          print('RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
          
          handler.next(response);
        },
        onError: (error, handler) {
          // Log error details
          print('ERROR: ${error.message}');
          print('ERROR RESPONSE: ${error.response?.data}');
          
          // Transform DioException to AppException
          final appException = ErrorHandler.handleError(error);
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: appException,
            type: error.type,
            response: error.response,
          ));
        },
      ),
    );
  }

  // GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  // POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  // PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  // DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  // Cancel all pending requests
  void cancelRequests({String? reason}) {
    _dio.close(force: true);
  }

  // Update API key
  void updateApiKey(String newApiKey) {
    _dio.interceptors.clear();
    _setupInterceptors();
  }
}