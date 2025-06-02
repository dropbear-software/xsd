import 'dart:convert';

import '../../helpers/whitespace.dart';

class XsdBooleanDecoder extends Converter<String, bool> {
  const XsdBooleanDecoder();

  @override
  bool convert(String input) {
    // As per XSD spec for boolean, whiteSpace is fixed to 'collapse'
    //
    String collapsedInput = processWhiteSpace(input, Whitespace.collapse); //

    if (collapsedInput == 'true' || collapsedInput == '1') {
      return true;
    } else if (collapsedInput == 'false' || collapsedInput == '0') {
      return false;
    } else {
      throw FormatException(
        'Invalid XML Schema boolean lexical value: "$input" (collapsed to "$collapsedInput")',
      );
    }
  }
}
