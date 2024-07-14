
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showFlushbar(context,message){
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    message: message,
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue[300],
    ),
    duration: Duration(seconds: 3),
    leftBarIndicatorColor: Colors.blue[300],
  )..show(context);
}