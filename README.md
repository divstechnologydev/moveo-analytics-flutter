# Moveo Analytics Flutter

<div align="center">
  <img src="https://www.moveo.one/assets/og_white.png" alt="Moveo Analytics Logo" width="200" />
</div>

## Table of Contents
- [Introduction](#introduction)
- [Quick Start Guide](#quick-start-guide)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Library Initialization](#library-initialization)
  - [Setup](#setup)
  - [Metadata and Additional Metadata](#metadata-and-additional-metadata)
  - [Track Data](#track-data)
- [Event Types and Actions](#event-types-and-actions)
- [Comprehensive Example Usage](#comprehensive-example-usage)
- [Obtain API Key](#obtain-api-key)
- [Dashboard Access](#dashboard-access)
- [Support](#support)

## Introduction

Welcome to the official Moveo One Flutter library.

Moveo One Analytics is a **user cognitive-behavioral analytics** tool that provides deep insights into user behavior and interaction patterns. The `moveo-analytics-flutter` SDK enables Flutter applications to leverage Moveo One's advanced analytics capabilities.

### **Key Features**
- **Semantic grouping of user actions**
- **Component-level analytics**
- **Non-intrusive integration**
- **Privacy-focused design**
- **Automatic data batching and transmission**

---

## Quick Start Guide

### Prerequisites

- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- A Moveo One API key

### Installation

Add the Moveo One Analytics Flutter SDK to your `pubspec.yaml`:

```yaml
dependencies:
  moveoone_flutter: ^0.0.14
```

Then, install the dependency:

```sh
flutter pub get
```

### Library Initialization

Initialize MoveoOne early in your application lifecycle, typically in the `main.dart` file.

```dart
import 'package:moveoone_flutter/moveo_one.dart';

void main() {
  // Initialize with your API key
  MoveoOne().initialize("your_api_key");
  
  runApp(const MyApp());
}
```

### Setup

Start a tracking session before tracking any events. This should be called **before any track() or tick() calls**.

```dart
// Start tracking session with context
MoveoOne().start("your_context_eg_onboarding-app-settings");

// Or with metadata
MoveoOne().start(
  "checkout_flow",
  metadata: {
    "app_version": "1.0.0",
    "platform": "mobile",
  }
);
```

### Metadata and Additional Metadata

#### **updateSessionMetadata()**

Updates current session metadata. Session metadata should split sessions by information that influences content or creates visually different variations of the same application. Sessions split by these parameters will be analyzed separately by our UX analyzer.

```dart
MoveoOne().updateSessionMetadata({
  "test": "a",
  "locale": "eng",
});
```

**When to Call This Method:**
- When important information about the user or session changes during the app's lifecycle
- **Don't call before session starts**
- Use for parameters that create different visual or content variations
- **Session metadata examples:**
  - `sessionMetadata.put("test", "a");`
  - `sessionMetadata.put("locale", "eng");`
  - `sessionMetadata.put("app_version", "2.1.0");`


#### **updateAdditionalMetadata()**

Updates additional metadata for the session. This is used as data enrichment and enables specific queries or analysis by the defined split.

```dart
MoveoOne().updateAdditionalMetadata({
  "user_country": "US",
  "company": "example_company",
  "user_role": "admin", // or "user", "manager", "viewer"
  "acquisition_channel": "organic", // or "paid", "referral", "direct"
  "device_category": "mobile", // or "desktop", "tablet"
  "subscription_plan": "pro", // or "basic", "enterprise"
  "has_purchased": "true", // or "false"
});
```

**When to Call This Method:**
- For secondary or experimental data
- When you want to track data separately from main session metadata
- **Don't call before session starts**
- Use for data enrichment and specific analysis queries
- **Additional metadata examples:**
  - `additionalMetadata.put("app_version", "2.1.0");`
  - `additionalMetadata.put("user_country", "US");`
  - `additionalMetadata.put("company", "example_company");`
  - `additionalMetadata.put("user_role", "admin"); // or "user", "manager", "viewer"`
  - `additionalMetadata.put("acquisition_channel", "organic"); // or "paid", "referral", "direct"`
  - `additionalMetadata.put("device_category", "mobile"); // or "desktop", "tablet"`
  - `additionalMetadata.put("subscription_plan", "pro"); // or "basic", "enterprise"`
  - `additionalMetadata.put("has_purchased", "true"); // or "false"`

### Track Data

#### **track() Method**

Tracks events with explicit context specification.

```dart
MoveoOne().track(
  "home_screen", // Context
  MoveoOneData(
    semanticGroup: "navigation",
    id: "btn_submit",
    type: MoveoOneType.button,
    action: MoveoOneAction.tap,
    value: "Submit button clicked",
    metadata: {},
  ),
);
```

**When to Use track():**
- When you want to explicitly specify the event context
- When you need to change context between events
- When you want to use a different context than the one specified in start()

#### **tick() Method**

Tracks events using the context from the start() method.

```dart
MoveoOne().tick(
  MoveoOneData(
    semanticGroup: "user_interactions",
    id: "main_button",
    type: MoveoOneType.button,
    action: MoveoOneAction.appear,
    value: "primary_action",
    metadata: {},
  ),
);
```

**When to Use tick():**
- When tracking events within the same context
- When you want tracking without explicitly defining context
- When you want to track events in the same context specified in start()

#### **Understanding Context and Semantic Groups**

**Context:**
- Represents large, independent parts of the application
- Serves to divide the app into functional units that can exist independently
- Examples: `onboarding`, `main_app_flow`, `checkout_process`

**Semantic Groups:**
- Logical units within a context that group related elements
- Could be a group of elements or an entire screen (most common)
- Examples: `navigation`, `user_input`, `content_interaction`

#### **Method Call Order**

1. **initialize()** - Set up the library with API key
2. **start()** - Begin tracking session (required before any tracking)
3. **updateSessionMetadata()** / **updateAdditionalMetadata()** - Set metadata (optional)
4. **track()** / **tick()** - Track user interactions
5. **updateSessionMetadata()** / **updateAdditionalMetadata()** - Update metadata as needed

---

## Event Types and Actions

### **Event Types (MoveoOneType)**

| Type | Description | Use Case |
|------|-------------|----------|
| `button` | Clickable buttons, action triggers | Submit buttons, navigation buttons |
| `text` | Text labels, descriptions | Headers, labels, descriptions |
| `textEdit` | Input fields | Text inputs, search bars |
| `image` | Image components | Product images, avatars |
| `images` | Multiple images | Image galleries |
| `imageScrollHorizontal` | Horizontal image scrolling | Image carousels |
| `imageScrollVertical` | Vertical image scrolling | Image lists |
| `picker` | Selection components | Date pickers, dropdowns |
| `slider` | Slider controls | Volume controls, range selectors |
| `switchControl` | Toggle switches | Settings toggles |
| `progressBar` | Progress indicators | Loading bars, upload progress |
| `checkbox` | Checkbox controls | Multi-select options |
| `radioButton` | Radio button controls | Single-select options |
| `table` | Tabular data | Data tables, lists |
| `collection` | Collection views | Grid layouts, lists |
| `segmentedControl` | Segmented controls | Tab bars, segmented buttons |
| `stepper` | Step indicators | Multi-step forms |
| `datePicker` | Date selection | Calendar pickers |
| `timePicker` | Time selection | Clock pickers |
| `searchBar` | Search functionality | Search inputs |
| `webView` | Web content | Embedded web pages |
| `scrollView` | Scrollable content | Scrollable lists, pages |
| `activityIndicator` | Loading indicators | Spinners, loading states |
| `video` | Video content | Video players |
| `videoPlayer` | Video player controls | Play, pause, seek controls |
| `audioPlayer` | Audio player controls | Music players |
| `map` | Map components | Location maps |
| `tabBar` | Tab navigation | Bottom tabs, top tabs |
| `tabBarPage` | Tab page content | Individual tab content |
| `tabBarPageTitle` | Tab page titles | Tab headers |
| `tabBarPageSubtitle` | Tab page subtitles | Tab subheaders |
| `toolbar` | Toolbar components | Action bars |
| `alert` | Alert dialogs | Popup alerts |
| `alertTitle` | Alert titles | Alert headers |
| `alertSubtitle` | Alert subtitles | Alert descriptions |
| `modal` | Modal dialogs | Popup modals |
| `toast` | Toast notifications | Brief notifications |
| `badge` | Badge indicators | Notification badges |
| `dropdown` | Dropdown menus | Selection menus |
| `card` | Card components | Content cards |
| `chip` | Chip components | Tags, filters |
| `grid` | Grid layouts | Grid views |
| `custom` | Custom components | Any other UI element |

### **Event Actions (MoveoOneAction)**

| Action | Description | Use Case |
|--------|-------------|----------|
| `appear` | Component becomes visible | Screen loads, element appears |
| `disappear` | Component becomes hidden | Screen unloads, element hides |
| `swipe` | Swipe gesture | Swipe navigation, dismiss |
| `scroll` | Scrolling events | List scrolling, page scrolling |
| `drag` | Drag gesture | Dragging elements |
| `drop` | Drop gesture | Dropping elements |
| `tap` | Single tap | Button clicks, navigation |
| `doubleTap` | Double tap | Zoom in, quick actions |
| `longPress` | Long press | Context menus, options |
| `pinch` | Pinch gesture | Zoom in/out |
| `zoom` | Zoom action | Image zoom, map zoom |
| `rotate` | Rotation gesture | Image rotation |
| `submit` | Form submission | Form submits, data saves |
| `select` | Selection action | Item selection |
| `deselect` | Deselection action | Item deselection |
| `hover` | Hover state | Mouse hover (web) |
| `focus` | Component focus | Input focus |
| `blur` | Component blur | Input blur |
| `input` | Text input | Typing, text entry |
| `valueChange` | Value changes | Slider changes, toggle switches |
| `dragStart` | Drag begins | Drag initiation |
| `dragEnd` | Drag ends | Drag completion |
| `refresh` | Refresh action | Pull to refresh |
| `play` | Play action | Video/audio play |
| `pause` | Pause action | Video/audio pause |
| `stop` | Stop action | Video/audio stop |
| `seek` | Seek action | Video/audio seeking |
| `error` | Error state | Error handling |
| `success` | Success state | Success feedback |
| `cancel` | Cancel action | Cancel operations |
| `retry` | Retry action | Retry operations |
| `share` | Share action | Content sharing |
| `expand` | Expand action | Expandable content |
| `collapse` | Collapse action | Collapsible content |
| `edit` | Edit action | Edit operations |
| `custom` | Custom action | Any other interaction |

---

## Comprehensive Example Usage

Here's a complete example showing how to integrate Moveo One Analytics in a Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:moveoone_flutter/moveo_one.dart';
import 'package:moveoone_flutter/models/moveo_one_data.dart';
import 'package:moveoone_flutter/models/constants.dart';

void main() {
  // Initialize MoveoOne with your API key
  MoveoOne().initialize("your_api_key_here");
  
  // Start tracking session
  MoveoOne().start(
    "main_app_flow",
    metadata: {
      "app_version": "1.0.0",
      "platform": "mobile",
      "user_type": "new_user",
    }
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moveo Analytics Demo',
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
  final TextEditingController _searchController = TextEditingController();
  double _sliderValue = 50.0;

  @override
  void initState() {
    super.initState();
    
    // Track screen appearance
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "screen_interaction",
        id: "home_screen",
        type: MoveoOneType.text,
        action: MoveoOneAction.appear,
        value: "Home screen loaded",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Track settings button tap
              MoveoOne().track(
                "settings_screen",
                MoveoOneData(
                  semanticGroup: "navigation",
                  id: "settings_button",
                  type: MoveoOneType.button,
                  action: MoveoOneAction.tap,
                  value: "Settings button clicked",
                ),
              );
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Track search input
                MoveoOne().tick(
                  MoveoOneData(
                    semanticGroup: "user_input",
                    id: "search_field",
                    type: MoveoOneType.textEdit,
                    action: MoveoOneAction.input,
                    value: value,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // Slider
            Text('Volume: ${_sliderValue.round()}%'),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
                
                // Track slider change
                MoveoOne().tick(
                  MoveoOneData(
                    semanticGroup: "settings",
                    id: "volume_slider",
                    type: MoveoOneType.slider,
                    action: MoveoOneAction.valueChange,
                    value: value.toString(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Track primary action
                      MoveoOne().tick(
                        MoveoOneData(
                          semanticGroup: "user_actions",
                          id: "primary_button",
                          type: MoveoOneType.button,
                          action: MoveoOneAction.tap,
                          value: "Primary action executed",
                        ),
                      );
                    },
                    child: const Text('Primary Action'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Track secondary action
                      MoveoOne().tick(
                        MoveoOneData(
                          semanticGroup: "user_actions",
                          id: "secondary_button",
                          type: MoveoOneType.button,
                          action: MoveoOneAction.tap,
                          value: "Secondary action executed",
                        ),
                      );
                    },
                    child: const Text('Secondary Action'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Image example
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  // Track image tap
                  MoveoOne().tick(
                    MoveoOneData(
                      semanticGroup: "content_interaction",
                      id: "sample_image",
                      type: MoveoOneType.image,
                      action: MoveoOneAction.tap,
                      value: "Sample image clicked",
                    ),
                  );
                },
                child: const Center(
                  child: Text('Sample Image (Tap to track)'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Track screen disappearance
    MoveoOne().tick(
      MoveoOneData(
        semanticGroup: "screen_interaction",
        id: "home_screen",
        type: MoveoOneType.text,
        action: MoveoOneAction.disappear,
        value: "Home screen unloaded",
      ),
    );
    
    _searchController.dispose();
    super.dispose();
  }
}
```

---

## Obtain API Key

To obtain an API key:

1. Visit [Moveo One App](https://app.moveo.one/)
2. Sign up for an account
3. Create a new project
4. Get your unique API token from the project settings
5. Contact us at **info@moveo.one** for integration support

---

## Dashboard Access

Once your data is being tracked, you can access your analytics through the Moveo One Dashboard at [https://app.moveo.one/](https://app.moveo.one/)

The dashboard provides:
- **Analytics viewing**
- **User behavior patterns**
- **Interaction flow visualization**
- **Custom report generation**
- **Data export capabilities**

---

## Support

For any issues or support, feel free to:
- Open an **issue** on our [GitHub repository](https://github.com/divstechnologydev/moveoone-flutter/issues)
- Email us at [**info@moveo.one**](mailto:info@moveo.one)

