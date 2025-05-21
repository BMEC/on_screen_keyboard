part of on_screen_keyboard;

/// Keys for Virtual Keyboard's rows.
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

/// Returns a list of `VirtualKeyboardKey` objects for Numeric keyboard.
List<VirtualKeyboardKey> _getKeyboardRowKeysNumeric(rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(_keyRowsNumeric[rowNum].length, (int keyNum) {
    // Get key string value.
    String key = _keyRowsNumeric[rowNum][keyNum];

    // Create and return new VirtualKeyboardKey object.
    return VirtualKeyboardKey(
      text: key,
      capsText: key.toUpperCase(),
      keyType: VirtualKeyboardKeyType.string,
    );
  });
}

/// Returns a list of `VirtualKeyboardKey` objects.
List<VirtualKeyboardKey> _getKeyboardRowKeys(
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
      return VirtualKeyboardKey(
        text: text,
        capsText: text.toUpperCase(),
        keyType: VirtualKeyboardKeyType.string,
      );
    }

    // Handle action key.
    else if (key is VirtualKeyboardKeyAction) {
      var action = virtualKeyboardLayout.keys[rowNum][keyNum]
          as VirtualKeyboardKeyAction;
      return VirtualKeyboardKey(
        keyType: VirtualKeyboardKeyType.action,
        action: action,
      );
    }
    throw Exception("Unhandled key type: ${key.runtimeType}");
  });
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRows(
    KeyboardLayout virtualKeyboardLayout) {
  // Generate lists for each keyboard row.
  return List.generate(virtualKeyboardLayout.keys.length,
      (int rowNum) => _getKeyboardRowKeys(virtualKeyboardLayout, rowNum));
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRowsNumeric() {
  // Generate lists for each keyboard row.
  return List.generate(_keyRowsNumeric.length, (int rowNum) {
    // Will contain the keyboard row keys.
    List<VirtualKeyboardKey> rowKeys = [];

    // We have to add Action keys to keyboard.
    switch (rowNum) {
      case 3:
        // String keys.
        rowKeys.addAll(_getKeyboardRowKeysNumeric(rowNum));

        // Right Shift
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.action,
              action: VirtualKeyboardKeyAction.backspace),
        );
        break;
      default:
        rowKeys = _getKeyboardRowKeysNumeric(rowNum);
    }

    return rowKeys;
  });
}
