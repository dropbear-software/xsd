import 'package:test/test.dart';
import 'package:xsd/src/types/xsd_time.dart';

void main() {
  group('XsdTime', () {
    test('parses floating time', () {
      final t = XsdTime.parse('12:00:00');
      expect(t.value.hour, 12);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.isFloating, isTrue);
      expect(t.originalOffset, isNull);
      expect(t.toString(), '12:00:00');
    });

    test('parses time with fractional seconds', () {
      final t = XsdTime.parse('12:00:00.123');
      expect(t.value.hour, 12);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.value.millisecond, 123);
      expect(t.isFloating, isTrue);
      expect(t.toString(), '12:00:00.123');
    });

    test('parses time with Z', () {
      final t = XsdTime.parse('12:00:00Z');
      expect(t.value.hour, 12);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.isFloating, isFalse);
      expect(t.originalOffset, Duration.zero);
      expect(t.toString(), '12:00:00Z');
    });

    test('parses time with offset', () {
      final t = XsdTime.parse('12:00:00+05:00');
      expect(t.value.hour, 12);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.isFloating, isFalse);
      expect(t.originalOffset, Duration(hours: 5));
      expect(t.toString(), '12:00:00+05:00');
    });

    test('parses time with negative offset', () {
      final t = XsdTime.parse('12:00:00-05:00');
      expect(t.value.hour, 12);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.isFloating, isFalse);
      expect(t.originalOffset, Duration(hours: -5));
      expect(t.toString(), '12:00:00-05:00');
    });

    test('parses time with the maximum negative offset', () {
      final t = XsdTime.parse('12:00:00-14:00');
      expect(t.value.hour, 12);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.isFloating, isFalse);
      expect(t.originalOffset, Duration(hours: -14));
      expect(t.toString(), '12:00:00-14:00');
    });

    test('parses time with the maximum positive offset', () {
      final t = XsdTime.parse('12:00:00+14:00');
      expect(t.value.hour, 12);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.isFloating, isFalse);
      expect(t.originalOffset, Duration(hours: 14));
      expect(t.toString(), '12:00:00+14:00');
    });

    test('parses 24:00:00 as 00:00:00', () {
      final t = XsdTime.parse('24:00:00');
      expect(t.value.hour, 0);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.isFloating, isTrue);
      expect(t.toString(), '00:00:00');
    });

    test('parses 24:00:00Z as 00:00:00Z', () {
      final t = XsdTime.parse('24:00:00Z');
      expect(t.value.hour, 0);
      expect(t.value.minute, 0);
      expect(t.value.second, 0);
      expect(t.isFloating, isFalse);
      expect(t.originalOffset, Duration.zero);
      expect(t.toString(), '00:00:00Z');
    });

    test('throws on invalid format', () {
      expect(() => XsdTime.parse('invalid'), throwsFormatException);
    });

    test('throws on invalid hour', () {
      expect(() => XsdTime.parse('25:00:00'), throwsFormatException);
    });

    test('throws on invalid minute', () {
      expect(() => XsdTime.parse('12:60:00'), throwsFormatException);
    });

    test('throws on invalid second', () {
      expect(() => XsdTime.parse('12:00:60'), throwsFormatException);
    });

    test('throws on invalid offset', () {
      // Offset > 14 hours
      expect(() => XsdTime.parse('12:00:00+14:01'), throwsFormatException);
      expect(() => XsdTime.parse('12:00:00-14:01'), throwsFormatException);
    });

    test('equality', () {
      final t1 = XsdTime.parse('12:00:00');
      final t2 = XsdTime.parse('12:00:00');
      final t3 = XsdTime.parse('12:00:00Z');
      expect(t1, t2);
      expect(t1, isNot(t3));
    });

    test('hashCode', () {
      final t1 = XsdTime.parse('12:00:00');
      final t2 = XsdTime.parse('12:00:00');
      expect(t1.hashCode, t2.hashCode);
    });

    test('compareTo', () {
      final t1 = XsdTime.parse('12:00:00');
      final t2 = XsdTime.parse('13:00:00');
      expect(t1.compareTo(t2), lessThan(0));
      expect(t2.compareTo(t1), greaterThan(0));
    });
  });
}
