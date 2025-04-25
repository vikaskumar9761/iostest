// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:iostest/apiservice/app_exceptions.dart';
import 'package:iostest/apiservice/setheader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiBaseHelper {
  Future<dynamic> getrequest(String url) async {
    //print('Api get, url $url');
    var responseJson;
    try {
      var header = await SetHeaderHttps.setHttpheader();
            final uri = Uri.parse(url);

      final response = await http.get(uri, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    // print('api get recieved! $responseJson');
    return responseJson;
  }

  Future<dynamic> postrequest(String url, dynamic body) async {
    // print('Api Post, url $url');
    var responseJson;
    try {
      var header = await SetHeaderHttps.setHttpheader();
                  final uri = Uri.parse(url);

      final response = await http.post(uri, body: body, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      throw FetchDataException('No Internet connection');
    }
    //print('api post.');
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    // print('Api Put, url $url');
    var responseJson;
    try {
      var header = await SetHeaderHttps.setHttpheader();
      final uri = Uri.parse(url);
      final response = await http.put(uri, body: body, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      //print('No net');
      throw FetchDataException('No Internet connection');
    }
    //print('api put.');
    // print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> deleterequest(String url) async {
    // print('Api delete, url $url');
    var apiResponse;
    try {
      var header = await SetHeaderHttps.setHttpheader();
            final uri = Uri.parse(url);
      final response = await http.delete(uri, headers: header);
      apiResponse = _returnResponse(response);
    } on SocketException {
      //  print('No net');
      throw FetchDataException('No Internet connection');
    }
    // print('api delete.');
    return apiResponse;
  }

  dynamic _returnResponse(http.Response response) {
    if (kDebugMode) {
      print("responseJson == ${response.statusCode}");
    }

    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        if (kDebugMode) {
          print("responseJson$responseJson");
        }
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  
}

