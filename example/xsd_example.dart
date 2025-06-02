import 'package:xsd/xsd.dart';

void main() {
  // Boolean values in XSD can be true, false, 0 or 1
  var dartBool = xsdBooleanCodec.decode('0');
  // Dart will convert 0 to false
  print('xsd:bool = 0 -> $dartBool');
}
