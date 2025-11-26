import 'package:test/test.dart';
import 'package:xsd/src/types/gregorian_day.dart';

void main() {
  group('NIST gDay Generated Tests', () {
    test('NISTXML-SV-IV-atomic-gDay-enumeration-1-1.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-1-2.xml', () {
      expect(() => GregorianDay.parse('---26'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-1-3.xml', () {
      expect(() => GregorianDay.parse('---30'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-1-4.xml', () {
      expect(() => GregorianDay.parse('---18'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-1-5.xml', () {
      expect(() => GregorianDay.parse('---30'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-2-1.xml', () {
      expect(() => GregorianDay.parse('---20'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-2-2.xml', () {
      expect(() => GregorianDay.parse('---10'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-2-3.xml', () {
      expect(() => GregorianDay.parse('---12'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-2-4.xml', () {
      expect(() => GregorianDay.parse('---18'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-2-5.xml', () {
      expect(() => GregorianDay.parse('---04'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-3-1.xml', () {
      expect(() => GregorianDay.parse('---12'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-3-2.xml', () {
      expect(() => GregorianDay.parse('---24'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-3-3.xml', () {
      expect(() => GregorianDay.parse('---12'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-3-4.xml', () {
      expect(() => GregorianDay.parse('---30'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-3-5.xml', () {
      expect(() => GregorianDay.parse('---24'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-4-1.xml', () {
      expect(() => GregorianDay.parse('---12'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-4-2.xml', () {
      expect(() => GregorianDay.parse('---05'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-4-3.xml', () {
      expect(() => GregorianDay.parse('---18'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-4-4.xml', () {
      expect(() => GregorianDay.parse('---12'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-4-5.xml', () {
      expect(() => GregorianDay.parse('---17'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-5-1.xml', () {
      expect(() => GregorianDay.parse('---21'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-5-2.xml', () {
      expect(() => GregorianDay.parse('---14'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-5-3.xml', () {
      expect(() => GregorianDay.parse('---13'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-5-4.xml', () {
      expect(() => GregorianDay.parse('---30'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-enumeration-5-5.xml', () {
      expect(() => GregorianDay.parse('---26'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-1-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-2-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-2-2.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-2-3.xml', () {
      expect(() => GregorianDay.parse('---21'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-2-4.xml', () {
      expect(() => GregorianDay.parse('---07'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-2-5.xml', () {
      expect(() => GregorianDay.parse('---24'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-3-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-3-2.xml', () {
      expect(() => GregorianDay.parse('---20'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-3-3.xml', () {
      expect(() => GregorianDay.parse('---24'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-3-4.xml', () {
      expect(() => GregorianDay.parse('---22'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-3-5.xml', () {
      expect(() => GregorianDay.parse('---29'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-4-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-4-2.xml', () {
      expect(() => GregorianDay.parse('---13'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-4-3.xml', () {
      expect(() => GregorianDay.parse('---06'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-4-4.xml', () {
      expect(() => GregorianDay.parse('---11'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-4-5.xml', () {
      expect(() => GregorianDay.parse('---14'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-5-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-5-2.xml', () {
      expect(() => GregorianDay.parse('---06'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-5-3.xml', () {
      expect(() => GregorianDay.parse('---22'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-5-4.xml', () {
      expect(() => GregorianDay.parse('---09'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxExclusive-5-5.xml', () {
      expect(() => GregorianDay.parse('---30'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-1-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-2-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-2-2.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-2-3.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-2-4.xml', () {
      expect(() => GregorianDay.parse('---02'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-2-5.xml', () {
      expect(() => GregorianDay.parse('---07'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-3-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-3-2.xml', () {
      expect(() => GregorianDay.parse('---06'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-3-3.xml', () {
      expect(() => GregorianDay.parse('---07'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-3-4.xml', () {
      expect(() => GregorianDay.parse('---10'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-3-5.xml', () {
      expect(() => GregorianDay.parse('---11'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-4-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-4-2.xml', () {
      expect(() => GregorianDay.parse('---02'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-4-3.xml', () {
      expect(() => GregorianDay.parse('---05'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-4-4.xml', () {
      expect(() => GregorianDay.parse('---08'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-4-5.xml', () {
      expect(() => GregorianDay.parse('---10'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-5-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-5-2.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-5-3.xml', () {
      expect(() => GregorianDay.parse('---25'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-5-4.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-maxInclusive-5-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-1-1.xml', () {
      expect(() => GregorianDay.parse('---02'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-1-2.xml', () {
      expect(() => GregorianDay.parse('---17'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-1-3.xml', () {
      expect(() => GregorianDay.parse('---26'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-1-4.xml', () {
      expect(() => GregorianDay.parse('---06'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-1-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-2-1.xml', () {
      expect(() => GregorianDay.parse('---21'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-2-2.xml', () {
      expect(() => GregorianDay.parse('---28'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-2-3.xml', () {
      expect(() => GregorianDay.parse('---21'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-2-4.xml', () {
      expect(() => GregorianDay.parse('---27'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-2-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-3-1.xml', () {
      expect(() => GregorianDay.parse('---05'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-3-2.xml', () {
      expect(() => GregorianDay.parse('---14'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-3-3.xml', () {
      expect(() => GregorianDay.parse('---25'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-3-4.xml', () {
      expect(() => GregorianDay.parse('---14'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-3-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-4-1.xml', () {
      expect(() => GregorianDay.parse('---05'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-4-2.xml', () {
      expect(() => GregorianDay.parse('---14'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-4-3.xml', () {
      expect(() => GregorianDay.parse('---20'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-4-4.xml', () {
      expect(() => GregorianDay.parse('---24'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-4-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minExclusive-5-1.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-1-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-1-2.xml', () {
      expect(() => GregorianDay.parse('---09'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-1-3.xml', () {
      expect(() => GregorianDay.parse('---17'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-1-4.xml', () {
      expect(() => GregorianDay.parse('---14'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-1-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-2-1.xml', () {
      expect(() => GregorianDay.parse('---16'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-2-2.xml', () {
      expect(() => GregorianDay.parse('---18'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-2-3.xml', () {
      expect(() => GregorianDay.parse('---16'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-2-4.xml', () {
      expect(() => GregorianDay.parse('---29'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-2-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-3-1.xml', () {
      expect(() => GregorianDay.parse('---24'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-3-2.xml', () {
      expect(() => GregorianDay.parse('---29'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-3-3.xml', () {
      expect(() => GregorianDay.parse('---24'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-3-4.xml', () {
      expect(() => GregorianDay.parse('---30'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-3-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-4-1.xml', () {
      expect(() => GregorianDay.parse('---08'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-4-2.xml', () {
      expect(() => GregorianDay.parse('---30'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-4-3.xml', () {
      expect(() => GregorianDay.parse('---27'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-4-4.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-4-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-minInclusive-5-1.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-1-1.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-1-2.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-1-3.xml', () {
      expect(() => GregorianDay.parse('---25'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-1-4.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-1-5.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-2-1.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-2-2.xml', () {
      expect(() => GregorianDay.parse('---25'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-2-3.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-2-4.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-2-5.xml', () {
      expect(() => GregorianDay.parse('---15'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-3-1.xml', () {
      expect(() => GregorianDay.parse('---02'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-3-2.xml', () {
      expect(() => GregorianDay.parse('---03'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-3-3.xml', () {
      expect(() => GregorianDay.parse('---04'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-3-4.xml', () {
      expect(() => GregorianDay.parse('---07'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-3-5.xml', () {
      expect(() => GregorianDay.parse('---05'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-4-1.xml', () {
      expect(() => GregorianDay.parse('---02'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-4-2.xml', () {
      expect(() => GregorianDay.parse('---22'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-4-3.xml', () {
      expect(() => GregorianDay.parse('---22'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-4-4.xml', () {
      expect(() => GregorianDay.parse('---22'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-4-5.xml', () {
      expect(() => GregorianDay.parse('---12'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-5-1.xml', () {
      expect(() => GregorianDay.parse('---14'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-5-2.xml', () {
      expect(() => GregorianDay.parse('---13'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-5-3.xml', () {
      expect(() => GregorianDay.parse('---14'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-5-4.xml', () {
      expect(() => GregorianDay.parse('---13'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-pattern-5-5.xml', () {
      expect(() => GregorianDay.parse('---11'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-whiteSpace-1-1.xml', () {
      expect(() => GregorianDay.parse('---01'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-whiteSpace-1-2.xml', () {
      expect(() => GregorianDay.parse('---25'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-whiteSpace-1-3.xml', () {
      expect(() => GregorianDay.parse('---22'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-whiteSpace-1-4.xml', () {
      expect(() => GregorianDay.parse('---26'), returnsNormally);
    });
    test('NISTXML-SV-IV-atomic-gDay-whiteSpace-1-5.xml', () {
      expect(() => GregorianDay.parse('---31'), returnsNormally);
    });
  });
}
