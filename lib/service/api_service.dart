import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fat_end_fit/service/api_config.dart';
import 'package:flutter/material.dart';
import '../utils/app_print.dart';
import '../utils/app_storage.dart';
import '../utils/app_toast.dart';

// API Response Model
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final int? statusCode;
  final dynamic error;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
    this.statusCode,
    this.error,
  });

  factory ApiResponse.success(T data, {String message = 'Success', int? statusCode}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode, dynamic error}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }
}

// Common API Service
class AppApi {
  static AppApi? _instance;
  late Dio _dio;

  // Singleton pattern
  static AppApi getInstance() {
    _instance ??= AppApi._internal();
    return _instance!;
  }

  AppApi._internal() {
    _dio = Dio();
    _setupInterceptors();
    final token = AppStorage().read<String>("token");
    if (token != null && token.isNotEmpty) {
      setAuthToken(token);
    }
  }

  Completer<void>? _refreshCompleter;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;

          if (statusCode == 401) {
            final refreshToken = AppStorage().read<String>("refreshToken");

            if (refreshToken == null || refreshToken.isEmpty) {
              AppLogs.log("❌ No refresh token found", tag: "TOKEN", color: Colors.red);
              return handler.next(error);
            }

            // if refresh already in progress → wait
            if (_refreshCompleter != null) {
              await _refreshCompleter!.future;

              // retry after wait
              return _retryRequest(error, handler);
            }

            // start new refresh
            _refreshCompleter = Completer<void>();
            try {
              AppLogs.log("🔄 Refreshing token...", tag: "TOKEN", color: Colors.yellow);

              final refreshResponse = await _dio.post(
                ApiConfig.refreshToken,
                data: {"refreshToken": refreshToken},
                options: Options(headers: {"Authorization": ""}), // refresh ma old token avoid
              );

              final refreshData = refreshResponse.data;

              if (refreshResponse.statusCode == 200 &&
                  refreshData != null &&
                  refreshData["success"] == true &&
                  refreshData["data"] != null) {
                final newAccessToken = refreshData["data"]["accessToken"];
                final newRefreshToken = refreshData["data"]["refreshToken"];

                if (newAccessToken != null) {
                  AppLogs.log("USER TOKEN NEW: $newAccessToken");
                  await AppStorage().save("token", newAccessToken);
                  setAuthToken(newAccessToken);
                }
                if (newRefreshToken != null) {
                  await AppStorage().save("refreshToken", newRefreshToken);
                }

                AppLogs.log("✅ Token refreshed", tag: "TOKEN", color: Colors.green);
                _refreshCompleter?.complete();

                // retry failed request with new token
                return _retryRequest(error, handler);
              } else {
                _refreshCompleter?.completeError(Exception("Token refresh failed"));
                return handler.next(error);
              }
            } catch (e) {
              _refreshCompleter?.completeError(e);
              return handler.next(error);
            } finally {
              _refreshCompleter = null;
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<void> _retryRequest(DioException error, ErrorInterceptorHandler handler) async {
    try {
      final newToken = AppStorage().read<String>("token");
      final newHeaders = Map<String, dynamic>.from(error.requestOptions.headers);
      newHeaders["Authorization"] = "Bearer $newToken";

      final cloneOptions = Options(
        method: error.requestOptions.method,
        headers: newHeaders,
        responseType: error.requestOptions.responseType,
        contentType: error.requestOptions.contentType,
      );

      final retryResponse = await _dio.request(
        error.requestOptions.path,
        data: error.requestOptions.data,
        queryParameters: error.requestOptions.queryParameters,
        options: cloneOptions,
      );

      return handler.resolve(retryResponse);
    } catch (e) {
      return handler.next(error);
    }
  }

  // Set base URL
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    AppLogs.log('Base URL set to: $baseUrl', tag: 'API_CONFIG', color: Colors.yellow);
  }

  // Set headers (like Authorization token)
  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
    AppLogs.log('Headers updated: $headers', tag: 'API_CONFIG', color: Colors.yellow);
  }

  // Set Authorization token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    AppLogs.log('Auth token set', tag: 'API_CONFIG', color: Colors.yellow);
  }

  // Set timeout
  void setTimeout({int connectTimeout = 30000, int receiveTimeout = 30000}) {
    _dio.options.connectTimeout = Duration(milliseconds: connectTimeout);
    _dio.options.receiveTimeout = Duration(milliseconds: receiveTimeout);
    AppLogs.log('Timeout set: Connect: ${connectTimeout}ms, Receive: ${receiveTimeout}ms',
        tag: 'API_CONFIG', color: Colors.yellow);
  }

  // Handle DioException and convert to ApiResponse
  ApiResponse<T> _handleError<T>(DioException error) {
    String errorMessage;
    int? statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage = error.response?.data['message'] ??
            error.response?.statusMessage ??
            'Server error occurred';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection';
        break;
      default:
        errorMessage = 'Unknown error occurred';
    }

    if(statusCode == 500){
      AppToast.error("Something went wrong, please try again later");
    }

    AppLogs.log(
      'API Error: $errorMessage (Status: $statusCode) API MESSAGE: ${error.message}',
      tag: 'API_ERROR_HANDLER',
      color: Colors.red,
    );

    return ApiResponse<T>.error(errorMessage, statusCode: statusCode, error: error);
  }

  // GET Request
  Future<ApiResponse<T>> get<T>(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    final fullUrl = "${_dio.options.baseUrl}$endpoint";

    try {
      AppLogs.log('GET Request: $endpoint', tag: 'API_GET', color: Colors.blue);

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      _logApiDetails(
        method: "GET",
        url: fullUrl,
        query: queryParameters,
        response: response,
      );

      return ApiResponse<T>.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      _logApiDetails(
        method: "GET",
        url: fullUrl,
        query: queryParameters,
        error: e,
      );
      return _handleError<T>(e);
    } catch (e) {
      AppLogs.log('Unexpected error in GET: $e', tag: 'API_ERROR', color: Colors.red);
      return ApiResponse<T>.error('Unexpected error occurred');
    }
  }

  // POST Request
  Future<ApiResponse<T>> post<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    final fullUrl = "${_dio.options.baseUrl}$endpoint";

    try {
      AppLogs.log('POST Request: $endpoint', tag: 'API_POST', color: Colors.blue);

      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      _logApiDetails(
        method: "POST",
        url: fullUrl,
        requestBody: data,
        query: queryParameters,
        response: response,
      );

      return ApiResponse<T>.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      _logApiDetails(
        method: "POST",
        url: fullUrl,
        requestBody: data,
        query: queryParameters,
        error: e,
      );
      return _handleError<T>(e);
    } catch (e) {

      AppLogs.log('Unexpected error in POST: $e', tag: 'API_ERROR', color: Colors.red);
      return ApiResponse<T>.error('Unexpected error occurred');
    }
  }

  // PUT Request
  Future<ApiResponse<T>> put<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    final fullUrl = "${_dio.options.baseUrl}$endpoint";

    try {
      AppLogs.log('PUT Request: $endpoint', tag: 'API_PUT', color: Colors.blue);

      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      AppLogs.log('Unexpected error in PUT: $e', tag: 'API_ERROR', color: Colors.red);
      return ApiResponse<T>.error('Unexpected error occurred');
    }
  }

  // DELETE Request
  Future<ApiResponse<T>> delete<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      AppLogs.log('DELETE Request: $endpoint', tag: 'API_DELETE', color: Colors.blue);

      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      AppLogs.log('Unexpected error in DELETE: $e', tag: 'API_ERROR', color: Colors.red);
      return ApiResponse<T>.error('Unexpected error occurred');
    }
  }

  // PATCH Request
  Future<ApiResponse<T>> patch<T>(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      AppLogs.log('PATCH Request: $endpoint', tag: 'API_PATCH', color: Colors.blue);

      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return ApiResponse<T>.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      AppLogs.log('Unexpected error in PATCH: $e', tag: 'API_ERROR', color: Colors.red);
      return ApiResponse<T>.error('Unexpected error occurred');
    }
  }

  // File Upload
  Future<ApiResponse<T>> uploadFile<T>(
      String endpoint,
      String filePath, {
        String fieldName = 'file',
        Map<String, dynamic>? additionalData,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      AppLogs.log('File Upload: $endpoint', tag: 'API_UPLOAD', color: Colors.blue);

      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );

      return ApiResponse<T>.success(
        response.data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      AppLogs.log('Unexpected error in file upload: $e', tag: 'API_ERROR', color: Colors.red);
      return ApiResponse<T>.error('File upload failed');
    }
  }

  // Download File
  Future<ApiResponse<String>> downloadFile(
      String endpoint,
      String savePath, {
        ProgressCallback? onReceiveProgress,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      AppLogs.log('File Download: $endpoint', tag: 'API_DOWNLOAD', color: Colors.blue);

      await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse<String>.success(savePath, message: 'File downloaded successfully');
    } on DioException catch (e) {
      return _handleError<String>(e);
    } catch (e) {
      AppLogs.log('Unexpected error in file download: $e', tag: 'API_ERROR', color: Colors.red);
      return ApiResponse<String>.error('File download failed');
    }
  }

  // Cancel all requests
  void cancelAllRequests() {
    _dio.close(force: true);
    AppLogs.log('All requests cancelled', tag: 'API_CANCEL', color: Colors.yellow);
  }

}

void _logApiDetails({
  required String method,
  required String url,
  dynamic requestBody,
  Map<String, dynamic>? query,
  Response? response,
  DioException? error,
}) {
  final buffer = StringBuffer();

  buffer.writeln("\n============= ${_getMethodColor(method)} $method =============");
  buffer.writeln("URL: $url");

  if (query != null && query.isNotEmpty) {
    buffer.writeln("Query Params: $query");
  }

  if (requestBody != null) {
    buffer.writeln("Request Body: $requestBody");
  }

  if (response != null) {
    buffer.writeln("Status Code: ${response.statusCode}");
    buffer.writeln("Response: ${response.data}");

    final msg = response.data is Map && response.data['message'] != null
        ? response.data['message']
        : null;
    if (msg != null) buffer.writeln("Message: $msg");
  }

  if (error != null) {
    final statusCode = error.response?.statusCode;
    final msg = error.response?.data?['message'] ?? error.message ?? 'Unknown error';
    buffer.writeln("Status Code: $statusCode");
    buffer.writeln("❌ Error: $msg");
  }

  buffer.writeln("============ ${error != null ? 'END (ERROR)' : 'END'}: $url =============\n");

  AppLogs.log(buffer.toString(), tag: 'API_LOG', color: error != null ? Colors.red : Colors.green);
}

String _getMethodColor(String method) {
  switch (method.toUpperCase()) {
    case 'GET': return '🟩';
    case 'POST': return '🟦';
    case 'PUT': return '🟨';
    case 'PATCH': return '🟧';
    case 'DELETE': return '🟥';
    default: return '⚪';
  }
}



// Setup interceptors for logging and error handling
// void _setupInterceptors() {
//   _dio.interceptors.add(
//     InterceptorsWrapper(
//       onRequest: (options, handler) {
//         AppLogs.log(
//           'REQUEST: ${options.method} ${options.uri}',
//           tag: 'API_REQUEST',
//           color: Colors.blue,
//         );
//         if (options.data != null) {
//           AppLogs.log(
//             'REQUEST DATA: ${options.data}',
//             tag: 'API_REQUEST',
//             color: Colors.cyan,
//           );
//         }
//         handler.next(options);
//       },
//       onResponse: (response, handler) {
//         AppLogs.log(
//           'RESPONSE: ${response.statusCode} ${response.data}',
//           tag: 'API_RESPONSE',
//           color: Colors.green,
//         );
//         handler.next(response);
//       },
//       onError: (error, handler) {
//         AppLogs.log(
//           'ERROR: ${error.response?.statusCode} ${error.requestOptions.uri}',
//           tag: 'API_ERROR',
//           color: Colors.red,
//         );
//         AppLogs.log(
//           'ERROR MESSAGE: ${error.message}',
//           tag: 'API_ERROR',
//           color: Colors.red,
//         );
//         handler.next(error);
//       },
//     ),
//   );
// }
// void _setupInterceptors() {
//   _dio.interceptors.add(
//     InterceptorsWrapper(
//       onRequest: (options, handler) {
//         AppLogs.log(
//           'REQUEST: ${options.method} ${options.uri}',
//           tag: 'API_REQUEST',
//           color: Colors.blue,
//         );
//         if (options.data != null) {
//           AppLogs.log(
//             'REQUEST DATA: ${options.data}',
//             tag: 'API_REQUEST',
//             color: Colors.cyan,
//           );
//         }
//         handler.next(options);
//       },
//       onResponse: (response, handler) {
//         AppLogs.log(
//           'RESPONSE: ${response.statusCode} ${response.data}',
//           tag: 'API_RESPONSE',
//           color: Colors.green,
//         );
//         handler.next(response);
//       },
//       onError: (error, handler) async {
//         final statusCode = error.response?.statusCode;
//
//         AppLogs.log(
//           'ERROR: $statusCode ${error.requestOptions.uri}',
//           tag: 'API_ERROR',
//           color: Colors.red,
//         );
//         AppLogs.log(
//           'ERROR MESSAGE: ${error.message}',
//           tag: 'API_ERROR',
//           color: Colors.red,
//         );
//
//         // 🔄 Handle Token Expiration (401)
//         if (statusCode == 401) {
//           final refreshToken = AppStorage().read<String>("refreshToken");
//
//           if (refreshToken != null && refreshToken.isNotEmpty) {
//             try {
//               AppLogs.log(
//                 'Refreshing token...',
//                 tag: 'TOKEN',
//                 color: Colors.yellow,
//               );
//
//               final refreshResponse = await _dio.post(
//                 ApiConfig.refreshToken,
//                 data: {"refreshToken": refreshToken},
//               );
//
//               final refreshData = refreshResponse.data;
//
//               AppLogs.log("refreshData - ${refreshData}");
//
//               if (refreshResponse.statusCode == 200 &&
//                   refreshData != null &&
//                   refreshData["statusCode"] == 200 &&
//                   refreshData["code"] == 1002) {
//                 final newAccessToken = refreshData["data"]["accessToken"];
//                 final newRefreshToken = refreshData["data"]["refreshToken"]; // 👈 may be null
//
//                 // Save new tokens
//                 if (newAccessToken != null) {
//                   await AppStorage().save("token", newAccessToken);
//                   setAuthToken(newAccessToken);
//                 }
//                 if (newRefreshToken != null) {
//                   await AppStorage().save("refreshToken", newRefreshToken);
//                 }
//
//                 AppLogs.log(
//                   'Token refreshed ✅',
//                   tag: 'TOKEN',
//                   color: Colors.green,
//                 );
//
//                 // 🔄 Retry the failed request
//                 final retryRequest = await _dio.request(
//                   error.requestOptions.path,
//                   data: error.requestOptions.data,
//                   queryParameters: error.requestOptions.queryParameters,
//                   options: Options(
//                     method: error.requestOptions.method,
//                     headers: error.requestOptions.headers,
//                   ),
//                 );
//
//                 return handler.resolve(retryRequest);
//               }
//             } catch (e) {
//               AppLogs.log(
//                 'Refresh token failed: $e',
//                 tag: 'TOKEN',
//                 color: Colors.red,
//               );
//
//               // 🔴 Remove tokens if refresh fails
//               // await AppStorage().remove("token");
//               // await AppStorage().remove("refreshToken");
//             }
//           }
//         }
//
//         // Other errors → forward with message
//         handler.next(error);
//       },
//     ),
//   );
// }

bool _isRefreshing = false;
final List<Function()> _retryQueue = [];

// void _setupInterceptors() {
//   _dio.interceptors.add(
//     InterceptorsWrapper(
//       onError: (error, handler) async {
//         final statusCode = error.response?.statusCode;
//
//         if (statusCode == 401) {
//           final refreshToken = await AppStorage().read<String>("refreshToken");
//
//           if (refreshToken == null || refreshToken.isEmpty) {
//             AppLogs.log("❌ No refresh token found", tag: "TOKEN", color: Colors.red);
//             return handler.next(error);
//           }
//
//           // 🔄 If already refreshing, queue the request
//           if (_isRefreshing) {
//             AppLogs.log("⏳ Queuing request until token refresh done",
//                 tag: "TOKEN", color: Colors.yellow);
//             final updatedHeaders = Map<String, dynamic>.from(error.requestOptions.headers);
//             updatedHeaders["Authorization"] = "Bearer ${AppStorage().read<String>("token")}";
//
//             _retryQueue.add(() async {
//               final retryResponse = await _dio.request(
//                 error.requestOptions.path,
//                 data: error.requestOptions.data,
//                 queryParameters: error.requestOptions.queryParameters,
//                 options: Options(
//                   method: error.requestOptions.method,
//                   headers: updatedHeaders,
//                 ),
//               );
//               handler.resolve(retryResponse);
//             });
//             return;
//           }
//
//           // 🔄 Start refreshing
//           _isRefreshing = true;
//           try {
//             AppLogs.log("Refreshing token...", tag: "TOKEN", color: Colors.yellow);
//
//             final refreshResponse = await _dio.post(
//               ApiConfig.refreshToken,
//               data: {"refreshToken": refreshToken},
//             );
//
//             final refreshData = refreshResponse.data;
//             AppLogs.log("refreshData - $refreshData", tag: "LOG", color: Colors.green);
//
//             if (refreshResponse.statusCode == 200 &&
//                 refreshData != null &&
//                 refreshData["success"] == true &&
//                 refreshData["data"] != null) {
//               final newAccessToken = refreshData["data"]["accessToken"];
//               final newRefreshToken = refreshData["data"]["refreshToken"];
//
//               if (newAccessToken != null) {
//                 await AppStorage().save("token", newAccessToken);
//                 setAuthToken(newAccessToken);
//               }
//               if (newRefreshToken != null) {
//                 await AppStorage().save("refreshToken", newRefreshToken);
//               }
//
//               AppLogs.log("✅ Token refreshed", tag: "TOKEN", color: Colors.green);
//
//               // Retry the original failed request
//               final retryResponse = await _dio.request(
//                 error.requestOptions.path,
//                 data: error.requestOptions.data,
//                 queryParameters: error.requestOptions.queryParameters,
//                 options: Options(
//                   method: error.requestOptions.method,
//                   headers: error.requestOptions.headers,
//                 ),
//               );
//
//               AppLogs.log(" [retryResponse] data : ${retryResponse.data}");
//               AppLogs.log(" [retryResponse] statusCode : ${retryResponse.statusCode}");
//               AppLogs.log(" [retryResponse] statusMessage : ${retryResponse.statusMessage}");
//
//               // Retry all queued requests
//               for (final queued in _retryQueue) {
//                 await queued();
//               }
//               _retryQueue.clear();
//
//               handler.resolve(retryResponse);
//               return;
//             } else {
//               AppLogs.log("❌ Token update failed: Token expired",
//                   tag: "LOG", color: Colors.red);
//               await AppStorage().remove("token");
//               await AppStorage().remove("refreshToken");
//             }
//           } catch (e) {
//             AppLogs.log("❌ Refresh error: $e", tag: "TOKEN", color: Colors.red);
//             await AppStorage().remove("token");
//             await AppStorage().remove("refreshToken");
//           } finally {
//             _isRefreshing = false;
//           }
//         }
//
//         handler.next(error);
//       },
//     ),
//   );
// }


// void _setupInterceptors() {
//   _dio.interceptors.add(
//     InterceptorsWrapper(
//       onError: (error, handler) async {
//         final statusCode = error.response?.statusCode;
//
//         if (statusCode == 401) {
//           final refreshToken = await AppStorage().read<String>("refreshToken");
//
//           if (refreshToken == null || refreshToken.isEmpty) {
//             AppLogs.log("❌ No refresh token found", tag: "TOKEN", color: Colors.red);
//             return handler.next(error);
//           }
//
//           // if a refresh is already happening, wait for it
//           if (_refreshCompleter != null) {
//             AppLogs.log("⏳ Waiting for ongoing token refresh...", tag: "TOKEN", color: Colors.yellow);
//             await _refreshCompleter!.future;
//
//             // retry request after refresh completes
//             final newHeaders = Map<String, dynamic>.from(error.requestOptions.headers);
//             newHeaders["Authorization"] = "Bearer ${AppStorage().read<String>("token")}";
//
//             final retryResponse = await _dio.request(
//               error.requestOptions.path,
//               data: error.requestOptions.data,
//               queryParameters: error.requestOptions.queryParameters,
//               options: Options(
//                 method: error.requestOptions.method,
//                 headers: newHeaders,
//               ),
//             );
//
//             return handler.resolve(retryResponse);
//           }
//
//           // start a new refresh
//           _refreshCompleter = Completer<void>();
//           try {
//             AppLogs.log("🔄 Refreshing token...", tag: "TOKEN", color: Colors.yellow);
//
//             final refreshResponse = await _dio.post(
//               ApiConfig.refreshToken,
//               data: {"refreshToken": refreshToken},
//             );
//
//             final refreshData = refreshResponse.data;
//             AppLogs.log("refreshData - $refreshData", tag: "TOKEN", color: Colors.green);
//
//             if (refreshResponse.statusCode == 200 &&
//                 refreshData != null &&
//                 refreshData["success"] == true &&
//                 refreshData["data"] != null) {
//               final newAccessToken = refreshData["data"]["accessToken"];
//               final newRefreshToken = refreshData["data"]["refreshToken"];
//
//               if (newAccessToken != null) {
//                 await AppStorage().save("token", newAccessToken);
//                 setAuthToken(newAccessToken);
//               }
//               if (newRefreshToken != null) {
//                 await AppStorage().save("refreshToken", newRefreshToken);
//               }
//
//               AppLogs.log("✅ Token refreshed", tag: "TOKEN", color: Colors.green);
//
//               _refreshCompleter?.complete(); // notify others
//
//               // retry the failed request immediately
//               final retryResponse = await _dio.request(
//                 error.requestOptions.path,
//                 data: error.requestOptions.data,
//                 queryParameters: error.requestOptions.queryParameters,
//                 options: Options(
//                   method: error.requestOptions.method,
//                   headers: error.requestOptions.headers,
//                 ),
//               );
//
//               return handler.resolve(retryResponse);
//             } else {
//               AppLogs.log("❌ Token refresh failed", tag: "TOKEN", color: Colors.red);
//               // await AppStorage().remove("token");
//               // await AppStorage().remove("refreshToken");
//               _refreshCompleter?.completeError(Exception("Token refresh failed"));
//             }
//           } catch (e) {
//             AppLogs.log("❌ Refresh error: $e", tag: "TOKEN", color: Colors.red);
//             // await AppStorage().remove("token");
//             // await AppStorage().remove("refreshToken");
//             _refreshCompleter?.completeError(e);
//           } finally {
//             _refreshCompleter = null;
//           }
//         }
//
//         handler.next(error);
//       },
//     ),
//   );
// }