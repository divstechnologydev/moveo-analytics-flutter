import 'package:flutter/material.dart';
import 'package:moveoone_flutter/moveoone_flutter.dart';
import 'package:moveoone_flutter/src/constants.dart';
import 'package:moveoone_flutter/src/moveo_one_data.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    super.initState();
    // Start context for second_screen
    MoveoOne().start("second_screen");
    // Track appear event for static text element
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "second_screen",
        id: "second_screen_text",
        type: MoveoOneType.text,
        action: MoveoOneAction.appear,
        value: "Second Screen",
        metadata: {"screen": "second_screen", "element": "second_screen_text", "fontSize": "24"},
      ),
    );
  }

  @override
  void dispose() {
    // Track disappear event for static text element
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "second_screen",
        id: "second_screen_text",
        type: MoveoOneType.text,
        action: MoveoOneAction.disappear,
        value: "Second Screen",
        metadata: {"screen": "second_screen", "element": "second_screen_text", "fontSize": "24"},
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Track view event for static text element
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "second_screen",
        id: "second_screen_text",
        type: MoveoOneType.text,
        action: MoveoOneAction.view,
        value: "Second Screen",
        metadata: {"screen": "second_screen", "element": "second_screen_text", "fontSize": "24"},
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
