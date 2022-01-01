import 'dart:io';

import 'package:flutter/material.dart';

class VideoList extends ChangeNotifier {
  List<File> videolists = <File>[];
  List<String> videopath = <String>[];

  int length() {
    return videolists.length;
  }
}
