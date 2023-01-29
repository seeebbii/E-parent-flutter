import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/utils/hive_database.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'api_config.dart';
import 'api_paths.dart';

enum RequestMethod {
  POST,
  GET,
  PUT,
  PATCH,
  DELETE,
}

class ApiService {
  static late dio.CancelToken cancelToken;

  static Future<Map<String, dynamic>?> request(String path,
      {required RequestMethod method, data, queryParameters}) async {
    log('Path: $path');
    log('method: ${describeEnum(method)}');
    log('queryParameters: $queryParameters');
    log('data: $data');
    try {
      ApiConfig().dio.options.headers[HttpHeaders.authorizationHeader] = HiveDatabase.getValue(HiveDatabase.authToken);
      ApiConfig().dio.options.method = describeEnum(method);
      cancelToken = dio.CancelToken();

      dio.Response response = await ApiConfig().dio.request(
            path,
            data: data == null ? null : dio.FormData.fromMap(data),
            queryParameters: queryParameters,
            onSendProgress: (int sent, int total) => debugPrint("SENT: $sent TOTAL: $total"),
            cancelToken: cancelToken,
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                },
                headers: {
                  "Accept": "application/json",
                  'Content-type': 'application/json; charset=UTF-8',
                  'X-Requested-With': 'XMLHttpRequest'
                }),
          );

      // log(response.data.toString());
      if (response.statusCode == 200) {
        return response.data;
      }else{
        return response.data;
      }
    } on dio.DioError catch (e) {

      if(e.type == DioErrorType.connectTimeout){
        BaseHelper.showSnackBar("Connection Timed Out");
      }

      log("$path >>>>> ${e.response}");
      if (e.response?.statusCode != 500) {
        return e.response?.data;
      }
    }

    return null;
  }
}
