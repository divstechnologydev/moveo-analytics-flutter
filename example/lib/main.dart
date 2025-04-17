import 'package:flutter/material.dart';
import 'package:moveoone_flutter/moveoone_flutter.dart';
import 'package:moveoone_flutter/src/constants.dart';
import 'package:moveoone_flutter/src/moveo_one_data.dart';
import 'package:flutter/material.dart';
import 'package:moveoone_flutter/moveoone_flutter.dart';

void main() {
  MoveoOne().initialize("iLtwRUOaZepHcIcw");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF0F8FF),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    MoveoOne().start("main_screen"); // Must be called before any track/tick

    MoveoOne().identify("demo_user_123");

    // Track element impression with metadata in tick
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "content_interactions",
        id: "intro_paragraph",
        type: MoveoOneType.text,
        action: MoveoOneAction.appear,
        value: "demo_description",
        metadata: {
          "screen": "main_screen",
          "app_version": "1.0.0",
          "platform": "mobile",
        },
      ),
    );
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "user_interactions",
        id: "main_button",
        type: MoveoOneType.button,
        action: MoveoOneAction.appear,
        value: "primary_action",
        metadata: {
          "source": "home_screen",
          "button": "main_button",
        },
      ),
    );
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "user_interactions",
        id: "main_input",
        type: MoveoOneType.textEdit,
        action: MoveoOneAction.appear,
        value: "text_entered",
        metadata: {
          "source": "home_screen",
        },
      ),
    );
  }

  void _handleButtonPress(String buttonName) {
    MoveoOne().track(
      "main_screen",
      MoveoOneData(
        semanticGroup: "user_interactions",
        id: "main_button",
        type: MoveoOneType.button,
        action: MoveoOneAction.tap,
        value: "primary_action",
        metadata: {
          "source": "home_screen",
          "button": buttonName,
        },
      ),
    );
  }

  void _handleInputEnd() {
    MoveoOne().track(
      "main_screen",
      MoveoOneData(
        semanticGroup: "user_interactions",
        id: "main_input",
        type: MoveoOneType.textEdit,
        action: MoveoOneAction.edit,
        value: "text_entered",
        metadata: {
          "source": "home_screen",
          "input_length": _inputController.text.length.toString(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'Moveo One',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A365D),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2B6CB0).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Text(
                    'This is an example Flutter app made for demo purposes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4A5568),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      _buildButton("Button One"),
                      const SizedBox(height: 16),
                      _buildButton("Button Two"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _inputController,
                    onSubmitted: (_) => _handleInputEnd(),
                    decoration: InputDecoration(
                      hintText: 'Type something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: text == "Button One"
            ? const Color(0xFF2B6CB0)
            : const Color(0xFF4299E1),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => _handleButtonPress(text),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();

    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "content_interactions",
        id: "intro_paragraph",
        type: MoveoOneType.text,
        action: MoveoOneAction.disappear,
        value: "demo_description",
        metadata: {
          "screen": "main_screen",
          "app_version": "1.0.0",
          "platform": "mobile",
        },
      ),
    );
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "user_interactions",
        id: "main_button",
        type: MoveoOneType.button,
        action: MoveoOneAction.disappear,
        value: "primary_action",
        metadata: {
          "source": "home_screen",
          "button": "main_button",
        },
      ),
    );
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "user_interactions",
        id: "main_input",
        type: MoveoOneType.textEdit,
        action: MoveoOneAction.disappear,
        value: "text_entered",
        metadata: {
          "source": "home_screen",
        },
      ),
    );

    super.dispose();
  }
}