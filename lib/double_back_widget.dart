part of "double_back.dart";

/// A widget that prevents accidental app closure on Android by requiring a double tap on the back button.
///
/// This widget wraps a [PopScope] and monitors back navigation attempts.
/// If the user taps back twice within a specified duration, the app closes.
class DoubleBackToCloseApp extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// An optional callback that is executed when the back button is pressed for the first time.
  /// If provided, the default SnackBar will not be shown.
  final void Function(BuildContext context)? onFirstPop;

  /// An optional condition to determine if the double-back logic should be active.
  /// If this returns `false`, the back navigation will behave normally (attempt to pop).
  final bool Function()? canPopCondition;

  /// The message to display in the default SnackBar.
  final String snackBarMessage;

  /// The duration to wait between taps to trigger the app exit.
  /// Also used as the duration for the default SnackBar.
  final Duration snackBarDuration;

  /// Creates a [DoubleBackToCloseApp] widget.
  const DoubleBackToCloseApp({
    super.key,
    required this.child,
    this.onFirstPop,
    this.snackBarDuration = const Duration(seconds: 2),
    this.canPopCondition,
    this.snackBarMessage = 'Double tap',
  });

  @override
  State<DoubleBackToCloseApp> createState() => _DoubleBackToCloseAppState();
}

/// The state for [DoubleBackToCloseApp].
class _DoubleBackToCloseAppState extends State<DoubleBackToCloseApp> {
  DateTime? _lastTimeBackWasPressed;

  /// Checks if the current platform is Android.
  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    // If not on Android, the double-back logic is bypassed.
    if (!_isAndroid) return widget.child;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Check the custom condition if provided.
        if (widget.canPopCondition != null && !widget.canPopCondition!()) {
          if (context.mounted) Navigator.of(context).maybePop();
          return;
        }

        final now = DateTime.now();
        final backButtonHasNotBeenPressedRecently =
            _lastTimeBackWasPressed == null ||
                now.difference(_lastTimeBackWasPressed!) > widget.snackBarDuration;

        if (backButtonHasNotBeenPressedRecently) {
          _lastTimeBackWasPressed = now;

          if (widget.onFirstPop != null) {
            widget.onFirstPop!(context);
          } else {
            _showDefaultSnackBar();
          }
        } else {
          // Exit the app after second tap.
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }

  /// Displays the default [SnackBar] with [widget.snackBarMessage].
  void _showDefaultSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.snackBarMessage),
        duration: widget.snackBarDuration,
      ),
    );
  }
}