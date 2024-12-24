import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';

class ToastsCustom {
  static void showToastSucess(String mess, BuildContext context) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: const Text("Thông báo", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
      description: RichText(
          text: TextSpan(text: mess)),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
    );
  }

  static void showToastError(String mess, BuildContext context) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: const Text("Thông báo", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
      description: RichText(
          text: TextSpan(text: mess)),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
    );
  }

  static void showToastWarning(String mess, BuildContext context) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: const Text("Thông báo", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),
      description: RichText(
          text: TextSpan(text: mess)),
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
    );
  }
}
