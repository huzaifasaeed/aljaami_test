import 'dart:convert';

import 'package:aljaami_test/model/countries.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  String baseUrl = "https://vipankumar.com/SmartHealth/api";
  final successCode = 200;

  Future<Countries?> getCountries() async {
    final response = await Dio().get("$baseUrl/getCountries");

    return parseResponse(response);
  }

  Countries? parseResponse(Response response) {
    if (response.statusCode == successCode) {
      return Countries.fromJson(response.data);
    } else {
      throw Exception('something went wrong...');
    }
  }
}
