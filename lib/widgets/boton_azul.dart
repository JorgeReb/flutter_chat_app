import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final String text;
  final Function onPressed;

  const BotonAzul({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
        textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white)),
        fixedSize: MaterialStateProperty.all(const Size.fromWidth(700)),
        shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white),),
    );
  }
}
