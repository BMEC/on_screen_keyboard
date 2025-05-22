part of on_screen_keyboard;

/// Keyboard key.
class KeyboardKey {
  String? text;
  String? capsText;
  final KeyboardKeyType keyType;
  final KeyboardKeyAction? action;

  KeyboardKey(

      {this.text, this.capsText, required this.keyType, this.action}) {
    if (this.text == null && this.action != null) {
      this.text = action == KeyboardKeyAction.space
          ? ' '
          : (action == KeyboardKeyAction.carriageReturn ? '\n' : '');
    }
    if (this.capsText == null && this.action != null) {
      this.capsText = action == KeyboardKeyAction.space
          ? ' '
          : (action == KeyboardKeyAction.carriageReturn ? '\n' : '');
    }
  }

}
