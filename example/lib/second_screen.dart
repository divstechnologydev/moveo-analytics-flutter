import 'package:flutter/material.dart';
import 'package:moveoone_flutter/moveoone_flutter.dart';
import 'package:moveoone_flutter/src/constants.dart';
import 'package:moveoone_flutter/src/moveo_one_data.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MoveoOne().track(
      "second_screen",
      MoveoOneData(
        semanticGroup: "second_screen",
        id: "second_screen_text",
        type: MoveoOneType.text,
        action: MoveoOneAction.view,
        value: "Second Screen",
        metadata: {"fontSize": "24"},
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: const Center(
        child: Text(
          'Second Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
