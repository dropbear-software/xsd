import 'package:test/test.dart';
import 'package:xsd/xsd.dart';

void main() {
  group('XsdAnyUriCodec', () {
    const codec = XsdAnyUriCodec();

    test('should encode valid URI', () {
      expect(
        codec.encode(Uri.parse('http://example.com')),
        'http://example.com',
      );
      expect(
        codec.encode(Uri.parse('urn:isbn:1234567890')),
        'urn:isbn:1234567890',
      );
    });

    test('should decode valid URI', () {
      expect(
        codec.decode('http://example.com'),
        Uri.parse('http://example.com'),
      );
      expect(
        codec.decode('  http://example.com  '),
        Uri.parse('http://example.com'),
      );
    });
  });
}
