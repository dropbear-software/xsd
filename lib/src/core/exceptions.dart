/// Exception thrown when a lexical representation does not conform to the
/// XSD 1.1 specification for a specific type.
class XsdValidationException implements Exception {
  /// The invalid lexical input.
  final String input;

  /// A message describing the validation failure.
  final String message;

  /// The XSD type that failed validation.
  final String? type;

  /// Creates a new [XsdValidationException].
  XsdValidationException(this.message, {required this.input, this.type});

  @override
  String toString() {
    final typePart = type != null ? ' for type $type' : '';
    return 'XsdValidationException$typePart: $message (Input: "$input")';
  }
}
