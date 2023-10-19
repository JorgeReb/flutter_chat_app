import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

mostrarAlert(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
   
        content: Row(children: [
          Text(subtitulo),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 30,
          )
        ]),
        actions: [
          InkWell(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration:  BoxDecoration(color: Colors.blue[700],),
              child: const Text(
                "Aceptar",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        alignment: Alignment.center,
      ),
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }
}
