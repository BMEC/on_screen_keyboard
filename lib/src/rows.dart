part of on_screen_keyboard;

/// Keys for keyboard's rows.
const List<List> _keyRowsNumeric = [
  // Row 1
  const [
    '1',
    '2',
    '3',
  ],
  // Row 1
  const [
    '4',
    '5',
    '6',
  ],
  // Row 1
  const [
    '7',
    '8',
    '9',
  ],
  // Row 1
  const [
    '.',
    '0',
  ],
];

/// Returns a list of `KeyboardKey` objects for Numeric keyboard.
List<KeyboardKey> _getKeyboardRowKeysNumeric(rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(_keyRowsNumeric[rowNum].length, (int keyNum) {
    // Get key string value.
    String key = _keyRowsNumeric[rowNum][keyNum];

    // Create and return new VirtualKeyboardKey object.
    return KeyboardKey(
      text: key,
      capsText: key.toUpperCase(),
      keyType: KeyboardKeyType.string,
    );
  });
}

/// Returns a list of `KeyboardKey` objects.
List<KeyboardKey> _getKeyboardRowKeys(
  KeyboardLayout virtualKeyboardLayout,
  rowNum,
) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(virtualKeyboardLayout.keys[rowNum].length, (int keyNum) {
    final dynamic key = virtualKeyboardLayout.keys[rowNum][keyNum];

    // Handle string key.
    if (key is String) {
      String text = virtualKeyboardLayout.keys[rowNum][keyNum];

      // Create and return new VirtualKeyboardKey object.
      return KeyboardKey(
        text: text,
        capsText: text.toUpperCase(),
        keyType: KeyboardKeyType.string,
      );
    }

    // Handle action key.
    else if (key is KeyboardKeyAction) {
      var action = virtualKeyboardLayout.keys[rowNum][keyNum]
          as KeyboardKeyAction;
      return KeyboardKey(
        keyType: KeyboardKeyType.action,
        action: action,
      );
    }
    throw Exception("Unhandled key type: ${key.runtimeType}");
  });
}

/// Returns a list of Keyboard rows with `KeyboardKey` objects.
List<List<KeyboardKey>> _getKeyboardRows(
    KeyboardLayout virtualKeyboardLayout) {
  // Generate lists for each keyboard row.
  return List.generate(virtualKeyboardLayout.keys.length,
      (int rowNum) => _getKeyboardRowKeys(virtualKeyboardLayout, rowNum));
}

/// Returns a list of Keyboard rows with `KeyboardKey` objects.
List<List<KeyboardKey>> _getKeyboardRowsNumeric() {
  // Generate lists for each keyboard row.
  return List.generate(_keyRowsNumeric.length, (int rowNum) {
    // Will contain the keyboard row keys.
    List<KeyboardKey> rowKeys = [];

    // We have to add Action keys to keyboard.
    switch (rowNum) {
      case 3:
        // String keys.
        rowKeys.addAll(_getKeyboardRowKeysNumeric(rowNum));

        // Right Shift
        rowKeys.add(
          KeyboardKey(
              keyType: KeyboardKeyType.action,
              action: KeyboardKeyAction.backspace),
        );
        break;
      default:
        rowKeys = _getKeyboardRowKeysNumeric(rowNum);
    }

    return rowKeys;
  });
}
