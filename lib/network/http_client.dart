import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:erp/network/response_wrapper.dart';
import 'package:erp/utils/log.dart';

import 'api_constants.dart';

const TAG = "httpClient";
const String APPLICATION = 'application';
const String JSON = 'json';
const String UTF8 = 'utf-8';

Future<Map<String, dynamic>> _httpRequest<T>(
  String method,
  String path, {
  dynamic body,
  Map<String, dynamic>? params,
  Map<String, String>? headers,
}) async {
  BaseOptions baseOptions = BaseOptions();
  baseOptions.baseUrl = ApiConstants.baseUrlLocal;
  baseOptions.connectTimeout = const Duration(seconds: 50); //5s
  baseOptions.receiveTimeout = const Duration(seconds: 50); //5s
  baseOptions.headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  Dio dio = Dio(baseOptions);
  // 配置dio实例
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions request, RequestInterceptorHandler handler) {
      Log.d("===Request Url===>${request.baseUrl}${request.path}");
      Log.d("===Request Data===>${request.data}");
      handler.next(request);
    },
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      Log.d("===Response Data=== ${jsonEncode((response.data as Map<String, dynamic>))}");
      handler.next(response);
    },
    onError: (
      DioException error,
      ErrorInterceptorHandler handler,
    ) {
      Log.d("===Error Message===>${error.message}");
      handler.next(error);
    },
  ));
  Response response;
  switch (method.toUpperCase()) {
    case 'GET':
      response = await dio.get(path, queryParameters: params);
      break;
    case 'POST':
      response = await dio.post(path, data: jsonEncode(body));
      break;
    case 'PUT':
      response = await dio.put(
        path,
        data: jsonEncode(body),
      );
      break;
    default:
      throw Exception("不支持的请求方法 $method");
  }
  if (response.data == null) {
    throw Exception("返回数据为null");
  }
  ResponseWrapper responseWrapper = ResponseWrapper.fromJson(response.data);
  if (responseWrapper.code != 200) {
    throw Exception(responseWrapper);
  } else {
    if (responseWrapper.data == null) {
      return {};
    } else {
      return responseWrapper.data!;
    }
  }
}

Future<Map<String, dynamic>> httpPost(
  url, {
  Map<String, dynamic>? params,
  Map<String, String>? headers,
  dynamic body,
}) async {
  return _httpRequest(
    "POST",
    url,
    params: params,
    headers: headers,
    body: body,
  );
}

Future<Map<String, dynamic>> httpPut(
  url, {
  Map<String, dynamic>? params,
  Map<String, String>? headers,
  dynamic body,
}) async {
  return _httpRequest(
    "PUT",
    url,
    params: params,
    headers: headers,
    body: body,
  );
}

Future<Map<String, dynamic>> httpGet(
  url, {
  Map<String, dynamic>? params,
  Map<String, String>? headers,
}) async {
  return _httpRequest(
    "GET",
    url,
    params: params,
    headers: headers,
  );
}
