part of on_screen_keyboard;

abstract class KeyboardLayout {
  final String switchIconText;
  final List<List<dynamic>> keys;

  const KeyboardLayout({
    required this.keys,
    required this.switchIconText,
  });
}

/// Default english keyboard.
class EnglishKeyboardLayout extends KeyboardLayout {
  /// Default english keys.
  static const List<List<dynamic>> defaultKeys = [
    // Row 1
    [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0',
    ],
    // Row 2
    [
      'q',
      'w',
      'e',
      'r',
      't',
      'y',
      'u',
      'i',
      'o',
      'p',
      VirtualKeyboardKeyAction.backspace
    ],
    // Row 3
    [
      'a',
      's',
      'd',
      'f',
      'g',
      'h',
      'j',
      'k',
      'l',
      ';',
      '\'',
      VirtualKeyboardKeyAction.carriageReturn
    ],
    // Row 4
    [
      VirtualKeyboardKeyAction.shift,
      'z',
      'x',
      'c',
      'v',
      'b',
      'n',
      'm',
      ',',
      '.',
      '/',
      VirtualKeyboardKeyAction.shift
    ],
    // Row 5
    [
      VirtualKeyboardKeyAction.switchLanguage,
      '@',
      VirtualKeyboardKeyAction.space,
      '-',
      '&',
      '_',
    ]
  ];

  const EnglishKeyboardLayout()
      : super(
          keys: defaultKeys,
          switchIconText: "abc",
        );
}

/// Extended english keyboard.
class EnglishExtendedKeyboardLayout extends KeyboardLayout {
  /// Extended character english keys.
  static const List<List<dynamic>> defaultKeys = [
    [
      'e',
      'é',
      'è',
      'ê',
      'ë',
      'u',
      'ü',
      'ù',
      'ú',
    ],
    [
      'a',
      'à',
      'á',
      'â',
      'ä',
      'å',
    ],
    [
      'o',
      'ò',
      'c',
      'ç',
      'n',
      'ñ',
    ],
    [
      VirtualKeyboardKeyAction.switchLanguage,
      VirtualKeyboardKeyAction.shift,
      VirtualKeyboardKeyAction.space,
      VirtualKeyboardKeyAction.shift,
      VirtualKeyboardKeyAction.backspace,
    ],
  ];

  const EnglishExtendedKeyboardLayout()
      : super(
          keys: defaultKeys,
          switchIconText: "éüâ",
        );
}

/// Default arabic keyboard.
class ArabicKeyboardLayout extends KeyboardLayout {
  /// Default arabic keys.
  static const List<List<dynamic>> defaultKeys = [
    // Row 1
    [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0',
    ],
    // Row 2
    [
      'ض',
      'ص',
      'ث',
      'ق',
      'ف',
      'غ',
      'ع',
      'ه',
      'خ',
      'ح',
      'ج',
      'د',
      VirtualKeyboardKeyAction.backspace
    ],
    // Row 3
    [
      'ش',
      'س',
      'ي',
      'ب',
      'ل',
      'ا',
      'ت',
      'ن',
      'م',
      'ك',
      'ط',
      VirtualKeyboardKeyAction.carriageReturn
    ],
    // Row 4
    [
      'ذ',
      'ئ',
      'ء',
      'ؤ',
      'ر',
      'لا',
      'ى',
      'ة',
      'و',
      'ز',
      'ظ',
      VirtualKeyboardKeyAction.shift
    ],
    // Row 5
    [
      VirtualKeyboardKeyAction.switchLanguage,
      '@',
      VirtualKeyboardKeyAction.space,
      '-',
      '.',
      '_',
    ]
  ];

  const ArabicKeyboardLayout()
      : super(
          keys: defaultKeys,
          switchIconText: "ضصث",
        );
}

/// Default kurdish keyboard.
class KurdishKeyboardLayout extends KeyboardLayout {
  /// Default kurdish keys.
  static const List<List<dynamic>> defaultKeys = [
    // Row 1
    [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0',
    ],
    // Row 2
    [
      'چ',
      'پ',
      'ق',
      'ڤ',
      'ف',
      'غ',
      'ھ',
      'خ',
      'ح',
      'ج',
    ],
    // Row 3
    [
      'ش',
      'س',
      'ی',
      'ب',
      'ل',
      'ا',
      'ت',
      'ن',
      'م',
      'ک',
      'گ',
    ],
    // Row 4
    [
      'ئ',
      'ڕ',
      'ر',
      'ێ',
      'ڵ',
      'ە',
      'و',
      'ز',
      'ۆ',
      'د',
      VirtualKeyboardKeyAction.backspace
    ],
    // Row 5
    [
      VirtualKeyboardKeyAction.switchLanguage,
      '@',
      VirtualKeyboardKeyAction.space,
      '-',
      '.',
      '_',
      VirtualKeyboardKeyAction.carriageReturn,
    ]
  ];

  const KurdishKeyboardLayout()
      : super(
          keys: defaultKeys,
          switchIconText: "چپق",
        );
}
