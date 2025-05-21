part of on_screen_keyboard;

/// Type for virtual keyboard key.
enum VirtualKeyboardKeyType {
  /// Can be action key - Return, Backspace, etc.
  action,
  /// Keys that have text value - `Letters`, `Numbers`, `@` `.`
  string,
}
