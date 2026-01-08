part of "double_back.dart";

class DoubleBackToCloseApp extends StatefulWidget {
  final Widget child;

  final void Function(BuildContext context)? onFirstPop;

  final bool Function()? canPopCondition;

  final String snackBarMessage;

  const DoubleBackToCloseApp({
    super.key,
    required this.child,
    this.onFirstPop,
    this.canPopCondition,
    this.snackBarMessage = 'Double tap',
  });

  @override
  State<DoubleBackToCloseApp> createState() => _DoubleBackToCloseAppState();
}

class _DoubleBackToCloseAppState extends State<DoubleBackToCloseApp> {
  DateTime? _lastTimeBackWasPressed;

  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    if (!_isAndroid) return widget.child;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (widget.canPopCondition != null && !widget.canPopCondition!()) {
          if (context.mounted) Navigator.of(context).maybePop();
          return;
        }

        final now = DateTime.now();
        final backButtonHasNotBeenPressedRecently =
            _lastTimeBackWasPressed == null ||
            now.difference(_lastTimeBackWasPressed!) >
                const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedRecently) {
          _lastTimeBackWasPressed = now;

          if (widget.onFirstPop != null) {
            widget.onFirstPop!(context);
          } else {
            _showDefaultSnackBar();
          }
        } else {
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }

  void _showDefaultSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.snackBarMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
