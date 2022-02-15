import 'package:flutter/material.dart';
import 'package:flutter_pg/injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter playground'),
        ),
        body: Container(),
      ),
    );
  }
}
