import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_editing_app/src/pages/crop_page.dart';
import 'package:video_editing_app/src/pages/merge_page.dart';
import 'package:video_editing_app/src/provider/video_list.dart';
import 'package:video_editor/video_editor.dart';

import 'src/pages/home_page.dart';
import 'src/pages/video_editor_page.dart';
import 'src/utils/fade_in_route.dart';



typedef RouterMethod = PageRoute Function(RouteSettings, Map<String, String>);

/*
* Page builder methods
*/
final Map<String, RouterMethod> _definitions = {
  '/': (settings, _) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        return const HomePage();
      },
    );
  },

};

Map<String, String>? _buildParams(String key, String name) {
  final uri = Uri.parse(key);
  final path = uri.pathSegments;
  final params = Map<String, String>.from(uri.queryParameters);

  final instance = Uri.parse(name).pathSegments;
  if (instance.length != path.length) {
    return null;
  }

  for (int i = 0; i < instance.length; ++i) {
    if (path[i] == '*') {
      break;
    } else if (path[i][0] == ':') {
      params[path[i].substring(1)] = instance[i];
    } else if (path[i] != instance[i]) {
      return null;
    }
  }
  return params;
}

Route buildRouter(RouteSettings settings) {
  print('VisitingPage: ${settings.name}');

  for (final entry in _definitions.entries) {
    final params = _buildParams(entry.key, settings.name!);
    if (params != null) {
      print('Visiting: ${entry.key} for ${settings.name}');
      return entry.value(settings, params);
    }
  }

  print('<!> Not recognized: ${settings.name}');
  return FadeInRoute(
    settings: settings,
    maintainState: false,
    builder: (_) {
      return Scaffold(
        body: Center(
          child: Text(
            '"${settings.name}"\nYou should not be here!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      );
    },
  );
}
void openHomePage(BuildContext context) {
  Navigator.of(context).pushNamed("/");
}
openVideoEditorPage(BuildContext context,File? file, VideoList? vlist){
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VideoEditorPage(
        file: file!,
        vlist:vlist!,
      ),
    ),
  );
}
openCropPage(BuildContext context,VideoEditorController? controller){
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CropPage(
       controller: controller!,
      ),
    ),
  );
}
openMergePage(BuildContext context,VideoEditorController? controller,VideoList? vlist){
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MergePage(
       controller: controller!,
       vlist:vlist!,
      ),
    ),
  );
}
