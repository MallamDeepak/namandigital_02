import 'dart:io';
import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final String? details;
  final int? statusCode;

  AppException(this.message, {this.details, this.statusCode});

  @override
  String toString() {
    return 'AppException: $message${details != null ? ' - $details' : ''}';
  }
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.details, super.statusCode});
}

class ServerException extends AppException {
  ServerException(super.message, {super.details, super.statusCode});
}

class CacheException extends AppException {
  CacheException(super.message, {super.details});
}

class ErrorHandler {
  static AppException handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return NetworkException(
        'No internet connection',
        details: 'Please check your internet connection and try again',
      );
    } else if (error is AppException) {
      return error;
    } else {
      return AppException(
        'An unexpected error occurred',
        details: error.toString(),
      );
    }
  }

  static NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout',
          details: 'The request took too long to complete',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleHttpError(error.response);

      case DioExceptionType.cancel:
        return NetworkException(
          'Request cancelled',
          details: 'The request was cancelled',
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          'Connection error',
          details: 'Failed to connect to the server',
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          'Security error',
          details: 'Invalid security certificate',
        );

      case DioExceptionType.unknown:
        return NetworkException(
          'Network error',
          details: error.message ?? 'Unknown network error occurred',
        );
    }
  }

  static NetworkException _handleHttpError(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    String message;
    String? details;

    switch (statusCode) {
      case 400:
        message = 'Bad request';
        details = _extractErrorMessage(data) ?? 'The request was invalid';
        break;
      case 401:
        message = 'Unauthorized';
        details = 'Invalid API key or authentication required';
        break;
      case 403:
        message = 'Forbidden';
        details = 'Access denied to the requested resource';
        break;
      case 404:
        message = 'Not found';
        details = 'The requested resource was not found';
        break;
      case 429:
        message = 'Too many requests';
        details = 'Rate limit exceeded. Please try again later';
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        message = 'Server error';
        details = 'The server encountered an error. Please try again later';
        break;
      default:
        message = 'HTTP error';
        details = 'HTTP $statusCode: ${_extractErrorMessage(data) ?? 'Unknown error'}';
    }

    return NetworkException(message, details: details, statusCode: statusCode);
  }

  static String? _extractErrorMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? data['detail'];
      } else if (data is String) {
        return data;
      }
    } catch (e) {
      // If we can't extract the message, return null
    }
    return null;
  }
}

class ErrorUtil {
  static String getDisplayMessage(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return exception.details ?? exception.message;
      case ServerException:
        return 'Server error. Please try again later.';
      case CacheException:
        return 'Local data error. Please refresh.';
      default:
        return exception.message;
    }
  }

  static bool isRetryable(AppException exception) {
    if (exception is NetworkException) {
      final statusCode = exception.statusCode;
      return statusCode == null || 
             statusCode >= 500 || 
             statusCode == 408 || 
             statusCode == 429;
    }
    return false;
  }
}