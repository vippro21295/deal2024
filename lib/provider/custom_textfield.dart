import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomTextField extends StatelessWidget {
  final String name;
  final String initValue;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.name,
    required this.initValue,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        enabled: true,
        readOnly: readOnly,
        maxLength: 100,
        initialValue: initValue,
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
      ),
    );
  }
}