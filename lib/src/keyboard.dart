part of on_screen_keyboard;

/// The default keyboard height. Can we override by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 300;

const int _virtualKeyboardBackspaceEventPeriod = 250;

/// On screen keyboard widget.
class OnScreenKeyboard extends StatefulWidget {
  /// Keyboard Type: Should be inited in creation time.
  final KeyboardType type;

  /// Callback for Key press event. Called with pressed `Key` object.
  /// will fire before adding key's text to controller if a controller is provided
  final Function(VirtualKeyboardKey key)? onTapDown;

  /// Callback for Key press event. Called with pressed `Key` object.
  /// will fire after adding key's text to controller if a controller is provided
  final Function(VirtualKeyboardKey key)? onTapUp;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Virtual keyboard height. Default is full screen width
  final double? width;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// List of available [KeyboardLayout].
  final List<KeyboardLayout> keyboardLayouts;

  /// the text controller go get the output and send the default input
  final TextEditingController? textController;

  /// The builder function will be called for each Key object.
  /// Returning null falls back on the default builder.
  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  /// inverse the layout to fix the issues with right to left languages.
  final bool reverseLayout;

  OnScreenKeyboard({Key? key,
    required this.type,
    this.onTapDown,
    this.onTapUp,
    this.builder,
    this.width,
    this.keyboardLayouts = const [
      EnglishKeyboardLayout(),
      EnglishExtendedKeyboardLayout(),
      ArabicKeyboardLayout(),
    ],
    this.textController,
    this.reverseLayout = false,
    this.height = _virtualKeyboardDefaultHeight,
    this.textColor = Colors.black,
    this.fontSize = 14,
    this.alwaysCaps = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OnScreenKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _OnScreenKeyboardState extends State<OnScreenKeyboard> {
  KeyboardType type = KeyboardType.alphanumeric;
  Function(VirtualKeyboardKey key)? preKeyPress;
  Function(VirtualKeyboardKey key)? postKeyPress;
  TextEditingController? textController;

  Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;
  late double height;
  double? width;
  late Color textColor;
  late double fontSize;
  late bool alwaysCaps;
  late bool reverseLayout;
  late List<KeyboardLayout> keyboardLayouts;
  late KeyboardLayout activeKeyboardLayout;

  // Text Style for keys.
  late TextStyle textStyle;

  // True if shift is enabled.
  bool isShiftEnabled = false;

  /// Increments to the next keyboard looping back to the start.
  void _switchActiveKeyboardLayout() =>
      activeKeyboardLayout =
      keyboardLayouts[(keyboardLayouts.indexOf(activeKeyboardLayout) + 1) %
          keyboardLayouts.length];

  /// Returns the [KeyboardLayout.switchIconText] for the next KeyboardLayout.
  String _getSwitchIconText() =>
    keyboardLayouts[(keyboardLayouts.indexOf(activeKeyboardLayout) + 1) %
        keyboardLayouts.length].switchIconText;


  void _onKeyPress(VirtualKeyboardKey key) {
    if (preKeyPress != null) preKeyPress!(key);

    if (key.keyType == VirtualKeyboardKeyType.string) {
      if (isShiftEnabled) {
        _insertText(key.capsText!);
      } else {
        _insertText(key.text!);
      }
    } else if (key.keyType == VirtualKeyboardKeyType.action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.backspace:
          {
            _backspace();
          }
          break;
        case VirtualKeyboardKeyAction.carriageReturn:
          {
            _insertText('\n');
          }
          break;
        case VirtualKeyboardKeyAction.space:
          {
            _insertText(key.text!);
          }
          break;
        case VirtualKeyboardKeyAction.shift:
          break;
        case VirtualKeyboardKeyAction.switchLanguage:
          {
            setState(() {
              _switchActiveKeyboardLayout();
            });
          }
          break;
        case null:
          throw RangeError("Unexpected key.action: ${key.action}");
      }
    }

    if (postKeyPress != null) postKeyPress!(key);
  }

  void _insertText(String myText) {
    if (textController != null) {
      final text = textController!.text;
      final textSelection = textController!.selection;
      final newText = text.replaceRange(
        (textSelection.start >= 0) ? textSelection.start : 0,
        (textSelection.end >= 0) ? textSelection.end : 0,
        myText,
      );
      final myTextLength = myText.length;
      textController!.text = newText;
      textController!.selection = textSelection.copyWith(
        baseOffset: min(
            textSelection.start + myTextLength, textController!.text.length),
        extentOffset: min(
            textSelection.start + myTextLength, textController!.text.length),
      );
    }
  }

  void _backspace() {
    if (textController != null) {
      final text = textController!.text;
      final textSelection = textController!.selection;
      final selectionLength = textSelection.end - textSelection.start;

      // There is a selection.
      if (selectionLength > 0) {
        final newText = text.replaceRange(
          textSelection.start,
          textSelection.end,
          '',
        );
        textController!.text = newText;
        textController!.selection = textSelection.copyWith(
          baseOffset: textSelection.start,
          extentOffset: textSelection.start,
        );
        return;
      }

      // The cursor is at the beginning.
      if (textSelection.start == 0) {
        return;
      }

      // Delete the previous character
      final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
      final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
      final newStart = textSelection.start - offset;
      final newEnd = textSelection.start;
      final newText = text.replaceRange(
        newStart,
        newEnd,
        '',
      );
      textController!.text = newText;
      textController!.selection = textSelection.copyWith(
        baseOffset: newStart,
        extentOffset: newStart,
      );
    }
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  void didUpdateWidget(OnScreenKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      preKeyPress = widget.onTapDown;
      postKeyPress = widget.onTapUp;
      height = widget.height;
      width = widget.width;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      alwaysCaps = widget.alwaysCaps;
      reverseLayout = widget.reverseLayout;
      textController = widget.textController;
      keyboardLayouts = widget.keyboardLayouts;
      activeKeyboardLayout = keyboardLayouts.first;
      // Init the Text Style for keys.
      textStyle = TextStyle(
        fontSize: fontSize,
        color: textColor,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    textController = widget.textController;
    width = widget.width;
    type = widget.type;
    keyboardLayouts = widget.keyboardLayouts;
    activeKeyboardLayout = keyboardLayouts.first;
    builder = widget.builder;
    preKeyPress = widget.onTapDown;
    postKeyPress = widget.onTapUp;
    height = widget.height;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;
    reverseLayout = widget.reverseLayout;
    // Init the Text Style for keys.
    textStyle = TextStyle(
      fontSize: fontSize,
      color: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return type == KeyboardType.numeric ? _numeric() : _alphanumeric();
  }

  Widget _alphanumeric() {
    return Container(
      height: height,
      width: width ?? MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  Widget _numeric() {
    return Container(
      height: height,
      width: width ?? MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    List<List<VirtualKeyboardKey>> keyboardRows =
    type == KeyboardType.numeric
        ? _getKeyboardRowsNumeric()
        : _getKeyboardRows(activeKeyboardLayout);

    // Generate keyboard row.
    List<Widget> rows = List.generate(keyboardRows.length, (int rowNum) {
      var items = List.generate(keyboardRows[rowNum].length, (int keyNum) {
        // Get the VirtualKeyboardKey object.
        VirtualKeyboardKey virtualKeyboardKey = keyboardRows[rowNum][keyNum];

        // Attempt to get the keyWidget from the builder.
        Widget? keyWidget =
        builder == null ? null : builder!(context, virtualKeyboardKey);

        // If the keyWidget is null then fallback on the default builders.
        if (keyWidget == null) {
          // Check the key type.
          switch (virtualKeyboardKey.keyType) {
            case VirtualKeyboardKeyType.string:
            // Draw String key.
              keyWidget = _keyboardDefaultKey(virtualKeyboardKey);
              break;
            case VirtualKeyboardKeyType.action:
            // Draw action key.
              keyWidget = _keyboardDefaultActionKey(virtualKeyboardKey);
              break;
          }
        }

        return keyWidget;
      });

      if (this.reverseLayout) items = items.reversed.toList();
      return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          // Generate keyboard keys
          children: items,
        ),
      );
    });

    return rows;
  }

  // True if long press is enabled.
  bool longPress = false;

  /// Creates default UI element for keyboard Key.
  Widget _keyboardDefaultKey(VirtualKeyboardKey key) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _onKeyPress(key);
        },
        child: Container(
          height: height / activeKeyboardLayout.keys.length,
          child: Center(
            child: Text(
              alwaysCaps
                  ? key.capsText!
                  : (isShiftEnabled ? key.capsText! : key.text!),
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardDefaultActionKey(VirtualKeyboardKey key) {
    // Holds the action key widget.
    Widget? actionKey;

    // Switch the action type to build action Key widget.

    switch (key.action!) {
      case VirtualKeyboardKeyAction.backspace:
        actionKey = GestureDetector(
            onLongPress: () {
              longPress = true;
              // Start sending backspace key events while longPress is true
              Timer.periodic(
                  Duration(milliseconds: _virtualKeyboardBackspaceEventPeriod),
                      (timer) {
                    if (longPress) {
                      _onKeyPress(key);
                    } else {
                      // Cancel timer.
                      timer.cancel();
                    }
                  });
            },
            onLongPressUp: () {
              // Cancel event loop
              longPress = false;
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Icon(
                Icons.backspace,
                color: textColor,
              ),
            ));
        break;
      case VirtualKeyboardKeyAction.shift:
        actionKey = Icon(Icons.arrow_upward, color: textColor);
        break;
      case VirtualKeyboardKeyAction.space:
        actionKey = actionKey = Icon(Icons.space_bar, color: textColor);
        break;
      case VirtualKeyboardKeyAction.carriageReturn:
        actionKey = Icon(
          Icons.keyboard_return,
          color: textColor,
        );
        break;
      case VirtualKeyboardKeyAction.switchLanguage:
        actionKey = Container(
          height: height / activeKeyboardLayout.keys.length,
          child: Center(
            child: Text(
              _getSwitchIconText(),
              style: textStyle,
            ),
          ),
        );
        break;
    }

    Widget widget = InkWell(
      onTap: () {
        if (key.action == VirtualKeyboardKeyAction.shift) {
          if (!alwaysCaps) {
            setState(() {
              isShiftEnabled = !isShiftEnabled;
            });
          }
        }

        _onKeyPress(key);
      },
      child: Container(
        alignment: Alignment.center,
        height: height / activeKeyboardLayout.keys.length,
        child: actionKey,
      ),
    );

    if (key.action == VirtualKeyboardKeyAction.space)
      return Expanded(flex: 6, child: widget);
    else
      return Expanded(child: widget);
  }
}
