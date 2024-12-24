import 'dart:convert';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:http/http.dart' as http;

class CommonService {
  static Future<List<dynamic>> getBestModel() async {
    var uri = Uri.parse('${urlApi}getBestModel');
    List<dynamic> listBestModel = [];

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['isError'] == false) {
          List<dynamic> results = data['lstobj'];
          if (results.isNotEmpty) {
            for (var item in results) {
              var it = {
                "id": item["Id"],
                "name": item["ModelName"] +
                    '-' +
                    item["ModelCode"] +
                    '-' +
                    item["ColorCode"]
              };
              listBestModel.add(it);
            }
          }
        } else {
          throw Exception(data["message"]);
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return listBestModel;
  }

  static Future<List<dynamic>> getDenyReason() async {
    var uri = Uri.parse('${urlApi}getDenyReason');

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['isError'] == false) {
          List<dynamic> results = data['lstobj'];
          return results;
        } else {
          throw Exception(data["message"]);
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<dynamic>> getHistoryCustomer(custId) async {
    var queryParameters = {"custId": custId};
    var uri = Uri.parse('${urlApi}getCustomerHistory')
        .replace(queryParameters: queryParameters);

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['isError'] == false) {
          List<dynamic> results = data['lstobj'];
          return results;
        } else {
          throw Exception(data["message"]);
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
