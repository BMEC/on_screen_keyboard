part of on_screen_keyboard;

/// Virtual Keyboard key
class VirtualKeyboardKey {
  String? text;
  String? capsText;
  final VirtualKeyboardKeyType keyType;
  final VirtualKeyboardKeyAction? action;

  VirtualKeyboardKey(

      {this.text, this.capsText, required this.keyType, this.action}) {
    if (this.text == null && this.action != null) {
      this.text = action == VirtualKeyboardKeyAction.space
          ? ' '
          : (action == VirtualKeyboardKeyAction.carriageReturn ? '\n' : '');
    }
    if (this.capsText == null && this.action != null) {
      this.capsText = action == VirtualKeyboardKeyAction.space
          ? ' '
          : (action == VirtualKeyboardKeyAction.carriageReturn ? '\n' : '');
    }
  }

}
