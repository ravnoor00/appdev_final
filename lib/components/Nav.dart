import 'package:flutter/material.dart';
import '../utils.dart';

PreferredSizeWidget? appBar(String title) {
  return AppBar(
    toolbarHeight: 100,
    title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
    centerTitle: true,
    backgroundColor: yellow,
    elevation: 0,
  );
}
