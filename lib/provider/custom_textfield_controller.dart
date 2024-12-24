import 'package:flutter/material.dart';

class CustomTextFieldController extends StatelessWidget {
  final String name;
  final TextEditingController controller;
  final bool readOnly;
  final double? marginbot;

  const CustomTextFieldController({
    super.key,
    required this.name,
    required this.controller,
    required this.readOnly,
    this.marginbot 
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: true,
      readOnly: readOnly,
      maxLength: 100,
      controller: controller,
      minLines: 1,
      maxLines: 1,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      decoration: InputDecoration(       
        isDense: true,
        labelText: name,
        counterText: "",
        filled: readOnly,
        fillColor:const Color.fromARGB(255, 241, 240, 240) ,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 4, 11, 144), fontSize: 13),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 15, 113, 174)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 3, 162, 8)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 45, 8, 231)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}


