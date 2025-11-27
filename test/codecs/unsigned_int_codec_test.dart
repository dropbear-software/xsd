import 'package:test/test.dart';
import 'package:xsd/src/codecs/unsigned_int/unsigned_int_codec.dart';

void main() {
  test('XSD Unsigned Int Codec -> Decode', () {
    const codec = XsdUnsignedIntCodec();
    final decoder = codec.decoder;

    expect(decoder.convert('12345'), equals(12345));
    expect(decoder.convert('0'), equals(0));
    expect(decoder.convert('4294967295'), equals(4294967295));
    expect(() => decoder.convert('-1'), throwsFormatException);
    expect(() => decoder.convert('4294967296'), throwsFormatException);
    expect(() => decoder.convert('abc'), throwsFormatException);
    expect(() => decoder.convert(''), throwsFormatException);
  });

  test('XSD Unsigned Int Codec -> Encode', () {
    const codec = XsdUnsignedIntCodec();
    final encoder = codec.encoder;

    expect(encoder.convert(12345), equals('12345'));
    expect(encoder.convert(0), equals('0'));
    expect(encoder.convert(4294967295), equals('4294967295'));
    expect(() => encoder.convert(-1), throwsFormatException);
    expect(() => encoder.convert(4294967296), throwsFormatException);
  });
}
