import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static void showToastSucess(String mess) => Fluttertoast.showToast(
      msg: mess,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white, fontSize: 16);    
  
  static void showToastError(String mess) => Fluttertoast.showToast(
      msg: mess,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white, fontSize: 16);    
      
}
