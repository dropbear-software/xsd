/// XSD whitespace normalization strategies.
///
/// See W3C XSD 1.1 Part 2, section 4.3.6.
enum XsdWhitespace {
  /// No changes are made to the input string.
  preserve,

  /// All occurrences of #x9 (tab), #xA (line feed), and #xD (carriage return)
  /// are replaced with #x20 (space).
  replace,

  /// After the processing implied by `replace`, contiguous sequences of
  /// #x20's are collapsed to a single #x20, and leading and trailing
  /// #x20's are removed.
  collapse,
}

/// Normalizes [input] according to the specified XSD whitespace [strategy].
///
/// This implementation strictly follows W3C XSD 1.1 Part 2, section 4.3.6,
/// using explicit code point mapping to ensure platform consistency and
/// compliance with the specification.
String normalizeWhitespace(String input, XsdWhitespace strategy) {
  if (strategy == XsdWhitespace.preserve) {
    return input;
  }

  // replace: #x9 (tab), #xA (line feed), and #xD (carriage return) -> #x20 (space)
  var result = input.replaceAll(RegExp('[\x09\x0A\x0D]'), '\x20');

  if (strategy == XsdWhitespace.replace) {
    return result;
  }

  // collapse: contiguous sequences of #x20 -> single #x20
  result = result.replaceAll(RegExp('\x20+'), '\x20');

  // collapse: remove #x20 at start and end
  // We avoid String.trim() as it removes other Unicode whitespace characters
  // that XSD specifies should be preserved if they are not #x20.
  if (result.startsWith('\x20')) {
    result = result.substring(1);
  }
  if (result.endsWith('\x20')) {
    result = result.substring(0, result.length - 1);
  }

  return result;
}
