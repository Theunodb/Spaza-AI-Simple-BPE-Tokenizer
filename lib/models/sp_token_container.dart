/// A class that represents a container for the tokens, token count, and character count of a text.
class SPTokenContainer {
  /// An list of integer tokens that represent the encoded text.
  final List<int>? tokens;

  /// An integer that represents the number of tokens in the encoded text.
  final int? tokenCount;

  /// An integer that represents the number of characters in the original text.
  final int? characterCount;

  /// A constructor for SPTokenContainer that initializes the object with an optional list of integer tokens, an optional number of tokens, and an optional number of characters.
  SPTokenContainer({this.tokens, this.tokenCount, this.characterCount});

  @override
  String toString() {
    /// A function that returns a formatted string representation of the object. It returns a string that displays the token list, token count, and character count.
    return 'tokens: $tokens, tokenCount: $tokenCount, characterCount: $characterCount';
  }
}
