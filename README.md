# Moveo Analytics Flutter

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Quick Start Guide](#quick-start-guide)
  - [Initialize](#initialize)
  - [Track Data](#track-data)
  - [Advanced Usage](#advanced-usage)
  - [Obtain API KEY](#obtain-api-key)
  - [Use Results](#use-results)

## Introduction

Welcome to the official Moveo One Flutter library.

Moveo One Analytics is a **user cognitive-behavioral analytics** tool that provides deep insights into user behavior and interaction patterns. The `moveo-analytics-flutter` SDK enables Flutter applications to leverage Moveo One’s advanced analytics capabilities.

### **Key Features**
- **Real-time user interaction tracking**
- **Semantic grouping of user actions**
- **Component-level analytics**
- **Non-intrusive integration**
- **Privacy-focused design**

---

## Installation

Add the Moveo One Analytics Flutter SDK to your `pubspec.yaml`:

```yaml
dependencies:
  moveoone_flutter: ^0.0.8
```

Then, install the dependency:

```sh
flutter pub get
```

---

## Quick Start Guide

Moveo One Flutter SDK is a pure Dart implementation of the Moveo One Analytics tracker, designed to be lightweight and easy to integrate.

### **1. Initialize**

Initialize MoveoOne early in your application lifecycle, typically in the `main.dart` file.

```dart
import 'package:moveoone_flutter/moveo_one.dart';

void main() {
  MoveoOne().initialize("your_api_key");

  // Starts the tracking session - optionally, place it to another place to start tracking
  // !!! but importantly prior to first track/tick event !!!
  MoveoOne().initialize("your_context_eg_onboarding-app-settings");

  runApp(const MyApp());
}
```

### **2. Identify User (Optional)**

The `identify` method helps track unique users in analytics.

```dart
MoveoOne().identify("user_123");
```

**Important Privacy Note:** Never use personally identifiable information (PII) as the userId. Instead:
- Use app-specific unique identifiers
- Consider hashed or encoded values
- Maintain a mapping in your backend

---

## **Track Data**

### **a) Semantic Groups**
Semantic groups provide context for your analytics data. Typically represent:
- Screens or views
- Functional areas
- User flow segments

Example usage:
```dart
"main_screen" // Main screen
"checkout"    // Checkout process
"profile"     // User profile
```

### **b) Component Types**
The library supports various UI component types:
- `MoveoOneType.text` - Text labels, descriptions
- `MoveoOneType.button` - Clickable buttons, action triggers
- `MoveoOneType.textEdit` - Input fields
- `MoveoOneType.image` - Image components
- `MoveoOneType.slider` - Sliders
- Custom types are supported

### **c) Actions**
Available tracking actions:
- `MoveoOneAction.tap` - User taps/clicks
- `MoveoOneAction.appear` - Component becomes visible
- `MoveoOneAction.scroll` - Scrolling events
- `MoveoOneAction.input` - Text input events
- `MoveoOneAction.focus` - Component focus events

---

## **Example Usage**
Here’s how to track a button click:

```dart
import 'package:moveoone_flutter/moveo_one.dart';
import 'package:moveoone_flutter/models/moveo_one_data.dart';
import 'package:moveoone_flutter/models/constants.dart';

void trackButtonClick() {
  MoveoOne().track(
    "home_screen",
    MoveoOneData(
      semanticGroup: "navigation",
      id: "btn_submit",
      type: MoveoOneType.button,
      action: MoveoOneAction.tap,
      value: "Submit button clicked",
      metadata: {"screen": "home"},
    ),
  );
}
```

---

## **Advanced Usage**

### **Tracking UI Interactions**
Track different types of interactions:

#### **Track Text Input**
```dart
MoveoOne().track(
  "profile_screen",
  MoveoOneData(
    semanticGroup: "user_input",
    id: "name_field",
    type: MoveoOneType.textEdit,
    action: MoveoOneAction.input,
    value: "John Doe",
    metadata: {"input_type": "name"},
  ),
);
```

#### **Track Slider Movement**
```dart
MoveoOne().track(
  "settings_screen",
  MoveoOneData(
    semanticGroup: "settings",
    id: "volume_slider",
    type: MoveoOneType.slider,
    action: MoveoOneAction.valueChange,
    value: "75",
    metadata: {"min": "0", "max": "100"},
  ),
);
```

---

## **Obtain API KEY**

To obtain an API key:
1. Contact us at **info@moveo.one**
2. Provide your application details
3. We will provide you with a unique API token
4. Integration support is available upon request

---

## **Use Results**

### **Data Ingestion**
The MoveoOne SDK handles:
- **Automatic data collection**
- **Efficient event batching**
- **Reliable data transmission**
- **Offline data queuing**

### **Dashboard Access**
The Moveo One Dashboard provides:
- **Real-time analytics viewing**
- **User behavior patterns**
- **Interaction flow visualization**
- **Custom report generation**
- **Data export capabilities**

For dashboard access, contact us.

---

## **Support**
For any issues or support, feel free to:
- Open an **issue** on our [GitHub repository](https://github.com/divstechnologydev/moveoone-flutter/issues)
- Email us at **info@moveo.one**

