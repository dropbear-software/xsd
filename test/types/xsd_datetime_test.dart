import 'package:test/test.dart';
import 'package:xsd/src/types/xsd_datetime.dart';

void main() {
  group('XsdDateTime', () {
    test('parses floating time', () {
      final dt = XsdDateTime.parse('2002-10-10T12:00:00');
      expect(dt.isFloating, isTrue);
      expect(dt.value.isUtc, isTrue);
      expect(dt.value.year, 2002);
      expect(dt.value.month, 10);
      expect(dt.value.day, 10);
      expect(dt.value.hour, 12);
      expect(dt.value.minute, 0);
      expect(dt.value.second, 0);
      expect(dt.originalOffset, isNull);
      expect(dt.toString(), '2002-10-10T12:00:00.000');
    });

    test('parses UTC time', () {
      final dt = XsdDateTime.parse('2002-10-10T12:00:00Z');
      expect(dt.isFloating, isFalse);
      expect(dt.value.isUtc, isTrue);
      expect(dt.originalOffset, Duration.zero);
      expect(dt.toString(), '2002-10-10T12:00:00.000Z');
    });

    test('parses offset time', () {
      final dt = XsdDateTime.parse('2002-10-10T12:00:00-05:00');
      expect(dt.isFloating, isFalse);
      expect(dt.value.isUtc, isTrue);
      // 12:00 -05:00 is 17:00 UTC
      expect(dt.value.hour, 17);
      expect(dt.originalOffset, const Duration(hours: -5));
      expect(dt.toString(), '2002-10-10T12:00:00.000-05:00');
    });

    test('parses positive offset time', () {
      final dt = XsdDateTime.parse('2002-10-10T12:00:00+05:30');
      expect(dt.isFloating, isFalse);
      expect(dt.value.isUtc, isTrue);
      // 12:00 +05:30 is 06:30 UTC
      expect(dt.value.hour, 6);
      expect(dt.value.minute, 30);
      expect(dt.originalOffset, const Duration(hours: 5, minutes: 30));
      expect(dt.toString(), '2002-10-10T12:00:00.000+05:30');
    });

    test('equality', () {
      final dt1 = XsdDateTime.parse('2002-10-10T12:00:00');
      final dt2 = XsdDateTime.parse('2002-10-10T12:00:00');
      final dt3 = XsdDateTime.parse('2002-10-10T12:00:00Z');

      expect(dt1, equals(dt2));
      expect(dt1.hashCode, equals(dt2.hashCode));
      expect(dt1, isNot(equals(dt3))); // Floating != Zoned
      expect(dt1.hashCode, isNot(equals(dt3.hashCode)));
    });

    test('compareTo', () {
      final dt1 = XsdDateTime.parse(
        '2002-10-10T12:00:00',
      ); // Floating (treated as UTC 12:00)
      final dt2 = XsdDateTime.parse('2002-10-10T13:00:00Z'); // UTC 13:00

      expect(dt1.compareTo(dt2), lessThan(0));
    });
  });
}
