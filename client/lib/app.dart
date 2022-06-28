import 'package:flutter/material.dart';

import 'views/convert/convert.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          onPrimary: Colors.white,
        ),
      ),
      home: const ConvertView(),
    );
  }
}
