import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Widget pictureFilePreviewWidget(
    String imagePath, Function submit, Function cancel) {
  return Stack(
    alignment: const Alignment(0, 0.9),
    children: [
//      Image.file(File(imagePath)),
      Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
        fit: BoxFit.cover,
//      image: Image.file(File(imagePath))
        image: new FileImage(File(imagePath)),
      ))),
      Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: FloatingActionButton(
                child: Icon(Icons.send),
                onPressed: () {
                  submit();
                }),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: FloatingActionButton(
                child: Icon(Icons.cancel),
                onPressed: () {
                  cancel();
                }),
          )
        ],
      )),
    ],
  );
}
