import '../codecs/boolean.dart';
import '../codecs/byte.dart';
import '../codecs/decimal.dart';
import '../codecs/double.dart';
import '../codecs/int.dart';
import '../codecs/integer.dart';
import '../codecs/long.dart';
import '../codecs/negative_integer.dart';
import '../codecs/non_negative_integer.dart';
import '../codecs/non_positive_integer.dart';
import '../codecs/positive_integer.dart';

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

  /// Codec for `xsd:long`.
  XsdLongCodec get long => const XsdLongCodec();

  /// Codec for `xsd:negativeInteger`.
  XsdNegativeIntegerCodec get negativeInteger =>
      const XsdNegativeIntegerCodec();

  /// Codec for `xsd:nonNegativeInteger`.
  XsdNonNegativeIntegerCodec get nonNegativeInteger =>
      const XsdNonNegativeIntegerCodec();

  /// Codec for `xsd:nonPositiveInteger`.
  XsdNonPositiveIntegerCodec get nonPositiveInteger =>
      const XsdNonPositiveIntegerCodec();

  /// Codec for `xsd:positiveInteger`.
  XsdPositiveIntegerCodec get positiveInteger =>
      const XsdPositiveIntegerCodec();
}
