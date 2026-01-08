# DoubleBackToCloseApp

A lightweight and flexible Flutter widget for Android that prevents accidental app exits by requiring a double-tap on the back button.

## Features

- **Modern API**: Uses `PopScope` (compatible with Flutter 3.16+).
- **Customizable**: Provide your own UI feedback (SnackBar, Toast, or Lottie).
- **Conditional**: Control exactly when the interceptor is active (e.g., only on the Home screen).
- **Platform Aware**: Automatically disables itself on iOS/macOS to respect system gestures.

## Installation

Copy the `double_back_to_close_app.dart` file into your project or add it to your local packages.

## Usage

### Simple Implementation
```dart
DoubleBackToCloseApp(
  child: Scaffold(
    body: Center(child: Text("Home Screen")),
  ),
)
