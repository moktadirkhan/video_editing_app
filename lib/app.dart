import 'package:flutter/material.dart';
import 'router.dart';

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
     return const MaterialApp(
      title: 'Video Editor',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: buildRouter,
    );
  }
}