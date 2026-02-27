import '../codecs/boolean.dart';

/// Global facade for XSD codecs.
const xsd = XsdFacade._();

/// Facade class to access all XSD codecs.
class XsdFacade {
  const XsdFacade._();

  /// Codec for `xsd:boolean`.
  XsdBooleanCodec get boolean => const XsdBooleanCodec();
}
