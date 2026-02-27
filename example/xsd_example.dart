// Using print for demonstration purposes
// ignore_for_file: avoid_print
import 'package:xsd/xsd.dart';

void main() {
  // Use the xsd facade for all operations
  print('--- xsd:boolean ---');
  final isEnabled = xsd.boolean.decode('true');
  print('Decoded boolean: $isEnabled');
  print('Encoded boolean: ${xsd.boolean.encode(false)}');

  // Validation
  try {
    xsd.boolean.decode('128');
  } on XsdValidationException catch (e) {
    print('Caught expected error: ${e.message}');
  }
}
