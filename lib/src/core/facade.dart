import '../codecs/boolean.dart';
import '../codecs/byte.dart';
import '../codecs/decimal.dart';
import '../codecs/double.dart';
import '../codecs/int.dart';
import '../codecs/integer.dart';

/// Global facade for XSD codecs.
const xsd = XsdFacade._();

/// Facade class to access all XSD codecs.
class XsdFacade {
  const XsdFacade._();

  /// Codec for `xsd:boolean`.
  XsdBooleanCodec get boolean => const XsdBooleanCodec();

  /// Codec for `xsd:byte`.
  XsdByteCodec get byte => const XsdByteCodec();

  /// Codec for `xsd:decimal`.
  XsdDecimalCodec get decimal => const XsdDecimalCodec();

  /// Codec for `xsd:double`.
  XsdDoubleCodec get double => const XsdDoubleCodec();

  /// Codec for `xsd:int`.
  XsdIntCodec get int => const XsdIntCodec();

  /// Codec for `xsd:integer`.
  XsdIntegerCodec get integer => const XsdIntegerCodec();
}
