import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'AppException.dart';

class ApiBaseHelper {
  //กำหนดหมายเลขไอพีแอดเดรสของเครื่อง server
  static final String _baseUrl = "http://54.169.37.117";
  static final _api = _baseUrl + "/user4/api";
  //กำหนด url ของ api endpoint สำหรับเรียกดูรายการสินค้าทั้งหมด
  static final getProduct = _api + "/products_image";
  //กำหนด url ของ api endpoint สำหรับเพิ่มข้อมูลสินค้า
  static final addNewProduct = _api + "/products";
  //กำหนด url ของ api endpoint สำหรับลบข้อมูลสินค้า
  static final deleteProduct = _api + "/products";
  //กำหนด url ของ api endpoint สำหรับลบข้อมูลสินค้า
  static final updateProduct = _api + "/products";
  //กำหนด url ของ api endpoint สำหรับการ ล็อกอิน
  static final userLogin = _api + "/userslogin";

  static final userUpdate = _api + "/users/";

  Future<Map<String, dynamic>> get({String? url, String? token}) async {
    http.Response responseData;
    Map<String, dynamic> data;
    Map<String, String> header;
    if (token != null) {
      header = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer ' + token,
      };
    } else {
      header = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }

    try {
      final response = await http.get(
        Uri.parse(url!),
        headers: header,
      );
      responseData = _returnResponse(response);
      if (response.statusCode == 200) {
        data = {'status': 'ok', 'data': jsonDecode(responseData.body)};
      } else {
        data = {'status': 'fail', 'data': 'Bad request'};
      }
    } on SocketException {
      data = {
        'status': 'fail',
        'data': 'Server unreachable, Please check internet connection.'
      };
      //throw FetchDataException('No Internet connection');
    } on HttpException {
      data = {'status': 'fail', 'data': 'Bad request'};
    } on UnauthorisedException {
      data = {'status': 'fail', 'data': 'Session timeout'};
    }
    return data;
  }

  //-------------------------------------------
  Future<Map<String, dynamic>> post({
    String? url,
    Map<String, String>? dataPost,
    String? token,
    int? statusCode,
    Map<String, String>? fileUpload,
  }) async {
    Map<String, dynamic> data;
    Map<String, String> header;
    if (token != null) {
      header = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'bearer ' + token,
      };
    } else {
      header = {
        'Content-Type': 'multipart/form-data',
      };
    }

    var request = http.MultipartRequest('POST', Uri.parse(url!))
      //ระบุข้อมูลที่จะส่งไปให้ api
      ..fields.addAll(dataPost!)
      //ระบุส่วนของ header จะทำการส่งไปให้ api
      ..headers.addAll(header);
    //ตรวจสอบว่ามีไฟล์ที่ต้องการอัพโหลดหรือไม่
    if (fileUpload != null) {
      //ระบุไฟล์ที่จะทำการส่งไปให้ api
      request.files.add(await http.MultipartFile.fromPath(
          fileUpload['fieldName']!, fileUpload['filePath']!));
    }

    try {
      //ส่งข้อมูลไปยัง api
      final response = await request.send();
      print('===' + userLogin + ' > ' + response.statusCode.toString());
      if (response.statusCode == statusCode) {
        data = {'status': 'ok', 'data': await response.stream.bytesToString()};
      } else {
        data = {'status': 'fail', 'data': 'Bad request'};
      }
    } on SocketException {
      data = {
        'status': 'fail',
        'data': 'Server unreachable, Please check internet connection.'
      };
      //throw FetchDataException('No Internet connection');
    } on HttpException {
      data = {'status': 'fail', 'data': 'Bad request'};
    } on UnauthorisedException {
      data = {'status': 'fail', 'data': 'Session timeout'};
    }

    return data;
  }

  //------------------ Manual Put ------------
  Future<Map<String, dynamic>> manualPut({
    String? url,
    Map<String, String>? dataPut,
    String? token,
    int? statusCode,
    Map<String, String>? fileUpload,
  }) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('PUT', Uri.parse(url!));
    request.bodyFields = dataPut!;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    Map<String, dynamic> responseData = {};
    try {
      if (response.statusCode == statusCode) {
        responseData = {
          'status': 'ok',
          'data': 'Success',
          "detail": await response.stream.bytesToString()
        };
      } else {
        responseData = {
          'status': 'fail',
          'data': 'Bad request',
          "detail": await response.stream.bytesToString()
        };
      }
    } on SocketException {
      responseData = {
        'status': 'fail',
        'data': 'Server unreachable, Please check internet connection.'
      };
      //throw FetchDataException('No Internet connection');
    } on HttpException {
      responseData = {'status': 'fail', 'data': 'Bad request'};
    } on UnauthorisedException {
      responseData = {'status': 'fail', 'data': 'Session timeout'};
    }

    return responseData;
  }

//-------------------------------------------
  Future<Map<String, dynamic>> put({
    String? url,
    Map<String, String>? dataPut,
    String? token,
    int? statusCode,
    Map<String, String>? fileUpload,
  }) async {
    Map<String, dynamic> data;
    Map<String, String> header;
    if (token != null) {
      header = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'bearer ' + token,
      };
    } else {
      header = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
    }

    var request = http.MultipartRequest('PUT', Uri.parse(url!));
    //  dataPut!.addAll({'_method': 'PUT'});
    //ระบุข้อมูลที่จะส่งไปให้ api
    request.fields.addAll(dataPut!);
    //ระบุส่วนของ header จะทำการส่งไปให้ api
    request.headers.addAll(header);
    //ตรวจสอบว่ามีไฟล์ที่ต้องการอัพโหลดหรือไม่
    if (fileUpload != null) {
      //ระบุไฟล์ที่จะทำการส่งไปให้ api
      request.files.add(await http.MultipartFile.fromPath(
          fileUpload['fieldName']!, fileUpload['filePath']!));
    }

    // Convert request details to a string
    String details = 'Method: ${request.method}';
    details += 'URL: ${request.url}';
    details += 'Headers: ${jsonEncode(request.headers)}';
    details += 'Fields: ${jsonEncode(request.fields)}';
    details += 'Files: ${request.files}';

    try {
      //ส่งข้อมูลไปยัง api
      final response = await request.send();
      if (response.statusCode == statusCode) {
        data = {'status': 'ok', 'data': 'Success', "detail": details};
      } else {
        data = {
          'status': 'fail',
          'data': 'Bad request',
          "detail": await response.stream.bytesToString()
        };
      }
    } on SocketException {
      data = {
        'status': 'fail',
        'data': 'Server unreachable, Please check internet connection.'
      };
      //throw FetchDataException('No Internet connection');
    } on HttpException {
      data = {'status': 'fail', 'data': 'Bad request'};
    } on UnauthorisedException {
      data = {'status': 'fail', 'data': 'Session timeout'};
    }

    return data;
  }

//-------------------------------------------
  Future<Map<String, dynamic>> delete({
    String? url,
    String? token,
    int? statusCode,
  }) async {
    Map<String, dynamic> data;
    Map<String, String> header;
    if (token != null) {
      header = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'bearer ' + token,
      };
    } else {
      header = {
        'Content-Type': 'multipart/form-data',
      };
    }

    var request = http.Request('DELETE', Uri.parse(url!));

    try {
      //ส่งข้อมูลไปยัง api
      http.StreamedResponse response = await request.send();
      if (response.statusCode == statusCode) {
        data = {'status': 'ok', 'data': 'Success'};
      } else {
        data = {'status': 'fail', 'data': 'Bad request'};
      }
    } on SocketException {
      data = {
        'status': 'fail',
        'data': 'Server unreachable, Please check internet connection.'
      };
      //throw FetchDataException('No Internet connection');
    } on HttpException {
      data = {'status': 'fail', 'data': 'Bad request'};
    } on UnauthorisedException {
      data = {'status': 'fail', 'data': 'Session timeout'};
    }

    return data;
  }

  //-------------------------------------------

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response;
        // print("body == " + responseJson.body);
        return responseJson;
      case 201:
        var responseJson = response;
        // print(responseJson.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
