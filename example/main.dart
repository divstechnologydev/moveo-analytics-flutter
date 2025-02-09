import 'package:flutter/material.dart';
import 'package:moveoone_flutter/moveoone_flutter.dart';
import 'package:moveoone_flutter/src/constants.dart';
import 'package:moveoone_flutter/src/moveo_one_data.dart';
import 'package:moveoone_flutter/src/moveo_one_entity.dart';

void main() {
  // Initialize MoveoOne before running the app
  MoveoOne().initialize("your_api_key");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoveoOne Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Identify user
    MoveoOne().identify("user_123");

    // Start session when the screen loads
    MoveoOne().start("home_screen");
  }

  void _trackButtonClick() {
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "first_screen",
        id: "btn_click_me",
        type: MoveoOneType.button,
        action: MoveoOneAction.click,
        value: "Click Me",
        metadata: {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Tracked: Button Clicked!")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MoveoOne Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _trackButtonClick,
              child: const Text("Click Me"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}