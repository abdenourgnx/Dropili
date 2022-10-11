import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:dropili/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  String? token;
        
  static String version = '/api/v1';

  static String host = 'http://8j1n9athcf.preview.infomaniak.website';
 //static String host = 'http://105.99.170.247:10001';
  static int timeOut = 60;

  _setHeadersWithToken() {
    return SharedPreferences.getInstance().then((storage) {
      String? token = storage.getString('access_token');
      return {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
    });
  }

  _setHeaders() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};

  Future<http.Response> postWithHeader(apiUrl, data) async {
    try {
      var fullUrl = host + version + apiUrl;
      final response = await http
          .post(Uri.parse(fullUrl),
              body: jsonEncode(data), headers: await _setHeadersWithToken())
          .timeout(Duration(seconds: timeOut));

      if (response.statusCode == 401) {
        throw Failure(message: 'authentication required');
      }
      return response;
    } on SocketException {
      throw 'Connection failed';
    } on TimeoutException {
      throw 'Connection failed';
    }
  }

  Future<http.Response> deleteWithHeader(apiUrl, data) async {
    try {
      var fullUrl = host + version + apiUrl;
      final response = await http
          .delete(Uri.parse(fullUrl),
              body: jsonEncode(data), headers: await _setHeadersWithToken())
          .timeout(Duration(seconds: timeOut));
      if (response.statusCode == 401) {
        throw Failure(message: 'authentication required');
      }
      return response;
    } on SocketException {
      throw 'Connection failed';
    } on TimeoutException {
      throw 'Connection failed';
    }
  }

  Future postPictureWithHeader(apiUrl, XFile file) async {
    try {
      var fullUrl = host + version + apiUrl;
      var request = http.MultipartRequest('POST', Uri.parse(fullUrl));
      request.headers.addAll(await _setHeadersWithToken());
      request.files.add(await http.MultipartFile.fromPath('image', file.path,
          filename: file.name));
      var res = await request.send();
      final respStr = await res.stream.bytesToString();
      // final response = json.decode(respStr);
      // if (response["data"]["status"] == 401) {
      //   throw Failure(message: 'authentication required');
      // }
      return respStr;
    } on SocketException {
      throw 'Connection failed';
    } on TimeoutException {
      throw 'Connection failed';
    }
  }

  Future postFileWithHeader(apiUrl, File file, data) async {
    try {
      var fullUrl = host + version + apiUrl;
      var request = http.MultipartRequest('POST', Uri.parse(fullUrl));
      request.headers.addAll(await _setHeadersWithToken());
      request.fields.addAll(data);
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
      ));

      var res = await request.send();
      final respStr = await res.stream.bytesToString();
      // final response = json.decode(respStr);
      // if (response["data"]["status"] == 401) {
      //   throw Failure(message: 'authentication required');
      // }
      return respStr;
    } on SocketException {
      throw 'Connection failed';
    } on TimeoutException {
      throw 'Connection failed';
    }
  }

  Future<http.Response> post(apiUrl, data) async {
    try {
      var fullUrl = host + version + apiUrl;
      final response = await http
          .post(Uri.parse(fullUrl),
              body: jsonEncode(data), headers: _setHeaders())
          .timeout(Duration(seconds: timeOut));
      if (response.statusCode == 401) {
        throw Failure(message: 'authentication required');
      }
      return response;
    } on SocketException catch (_) {
      throw 'Connection failed';
    } on TimeoutException catch (_) {
      throw 'Connection failed';
    }
  }

  Future<http.Response> getWithHeader(apiUrl) async {
    try {
      var fullUrl = host + version + apiUrl;

      final response = await http
          .get(Uri.parse(fullUrl), headers: await _setHeadersWithToken())
          .timeout(Duration(seconds: timeOut));
      if (response.statusCode == 401) {
        throw Failure(message: 'authentication required');
      }
      return response;
    } on SocketException catch (_) {
      throw 'Connection failed';
    } on TimeoutException catch (_) {
      throw 'Connection failed';
    }
  }

  Future<http.Response> get(apiUrl) async {
    try {
      var fullUrl = host + version + apiUrl;
      final response = await http
          .get(Uri.parse(fullUrl), headers: _setHeaders())
          .timeout(Duration(seconds: timeOut));
      if (response.statusCode == 401) {
        throw Failure(message: 'authentication required');
      }
      return response;
    } on SocketException catch (_) {
      throw 'Connection failed';
    } on TimeoutException catch (_) {
      throw 'Connection failed';
    }
  }

  Future<http.Response> patchWithHeader(apiUrl, data) async {
    try {
      var fullUrl = host + version + apiUrl;
      final response = await http
          .patch(Uri.parse(fullUrl),
              body: jsonEncode(data), headers: await _setHeadersWithToken())
          .timeout(Duration(seconds: timeOut));
      if (response.statusCode == 401) {
        throw Failure(message: 'authentication required');
      }
      return response;
    } on SocketException {
      throw 'Connection failed';
    } on TimeoutException {
      throw 'Connection failed';
    }
  }
}
