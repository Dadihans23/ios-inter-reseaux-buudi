import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importez cette bibliothèque pour utiliser les formatters


class CustomPhoneinput extends StatefulWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? prefixText ;

  const CustomPhoneinput({
    Key? key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
    this.prefixText,
  }) : super(key: key);

  @override
  _CustomPhoneinputState createState() => _CustomPhoneinputState();
}

class _CustomPhoneinputState extends State<CustomPhoneinput> {
  late TextEditingController _textEditingController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.controller ?? TextEditingController();
    _textEditingController.addListener(() {
      setState(() {
        _hasError = _textEditingController.text.length != 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 20),
      child: TextFormField(
        controller: _textEditingController,
        obscureText: widget.isPassword,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        keyboardType: TextInputType.number,
        maxLength: 10,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _hasError ? Colors.red : Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          // filled: true,
          // fillColor: Colors.transparent,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          prefixText: widget.prefixText, 
          prefixStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
