import 'package:flutter/material.dart';
import '../utils.dart';
import '../screens/note_image.dart';

PreferredSizeWidget? appBar(String title, BuildContext context) {
  return AppBar(
    
    toolbarHeight: 100,
    title: Text(title,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
    centerTitle: true,
    backgroundColor: yellow,
    elevation: 0,
    actions: [IconButton(icon: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 30,),
     onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ImageToText()),
        );
      },
    )
    ]
  );
}

