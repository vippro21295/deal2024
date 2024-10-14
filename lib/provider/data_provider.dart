import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dealxemay_2024/models/data_alert.dart';
import 'package:flutter_dealxemay_2024/services/globals.dart';
import 'package:http/http.dart' as http;

class AlertDataProvider with ChangeNotifier {
  List<DataAlert> _dataAlerts = [];
  List<DataAlert> get dataAlerts => _dataAlerts;

  Future<void> fetchDataAlert(String username) async{
    var queryParameters = {
      'username': username,
    };

    var uri = Uri.parse('${urlApi}getAlert')
        .replace(queryParameters: queryParameters);

    try {
      var response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body); // Giai ma JSON

        if (data['isError'] == false) {
          List<dynamic> results = data["listObj"];
          // Chuyển đổi danh sách JSON thành danh sách đối tượng DataObject
          List<DataAlert> dataObjects = results.map((item) {
            return DataAlert.fromJson(item);
          }).toList();

          _dataAlerts = dataObjects;

        } else {
          throw Exception('Error from API');
        }
      } else {
        throw Exception('Error from API');
      }
    } catch (error) {
      throw Exception('Failed to fetch data: $error');
    }
  }

  void refreshData() {
    fetchDataAlert("02010");
  }
}
