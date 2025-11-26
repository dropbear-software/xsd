import 'package:decimal/decimal.dart';
import 'package:test/test.dart';
import 'package:xsd/src/types/xsd_duration.dart';

void main() {
  group('XsdDuration', () {
    test('parse valid durations', () {
      expect(XsdDuration.parse('P1Y').months, 12);
      expect(XsdDuration.parse('P1M').months, 1);
      expect(XsdDuration.parse('P12M').months, 12);
      expect(XsdDuration.parse('P1Y1M').months, 13);

      expect(XsdDuration.parse('P1D').seconds, Decimal.fromInt(86400));
      expect(XsdDuration.parse('PT1H').seconds, Decimal.fromInt(3600));
      expect(XsdDuration.parse('PT1M').seconds, Decimal.fromInt(60));
      expect(XsdDuration.parse('PT1S').seconds, Decimal.fromInt(1));

      expect(
        XsdDuration.parse('P1DT1H').seconds,
        Decimal.fromInt(86400 + 3600),
      );

      final d = XsdDuration.parse('P1Y2M3DT4H5M6.7S');
      expect(d.months, 14);
      // 3*86400 + 4*3600 + 5*60 + 6.7 = 259200 + 14400 + 300 + 6.7 = 273906.7
      expect(d.seconds, Decimal.parse('273906.7'));
    });

    test('parse negative durations', () {
      final d = XsdDuration.parse('-P1Y');
      expect(d.months, -12);
      expect(d.seconds, Decimal.zero);
      expect(d.isNegative, isTrue);

      final d2 = XsdDuration.parse('-PT1S');
      expect(d2.months, 0);
      expect(d2.seconds, Decimal.fromInt(-1));
      expect(d2.isNegative, isTrue);
    });

    test('parse zero duration', () {
      final d = XsdDuration.parse('PT0S');
      expect(d.months, 0);
      expect(d.seconds, Decimal.zero);

      final d2 = XsdDuration.parse('P0Y');
      expect(d2.months, 0);
      expect(d2.seconds, Decimal.zero);
    });

    test('toString canonical representation', () {
      expect(XsdDuration(months: 13).toString(), 'P1Y1M');
      expect(XsdDuration(months: 12).toString(), 'P1Y');
      expect(XsdDuration(months: 1).toString(), 'P1M');

      expect(XsdDuration(seconds: Decimal.fromInt(86400)).toString(), 'P1D');
      expect(XsdDuration(seconds: Decimal.fromInt(3600)).toString(), 'PT1H');
      expect(XsdDuration(seconds: Decimal.fromInt(60)).toString(), 'PT1M');
      expect(XsdDuration(seconds: Decimal.fromInt(1)).toString(), 'PT1S');

      expect(
        XsdDuration(months: 14, seconds: Decimal.parse('273906.7')).toString(),
        'P1Y2M3DT4H5M6.7S',
      );

      expect(XsdDuration(months: -13).toString(), '-P1Y1M');
      expect(XsdDuration(seconds: Decimal.fromInt(-86400)).toString(), '-P1D');

      expect(XsdDuration().toString(), 'PT0S');
    });

    test('equality', () {
      expect(XsdDuration(months: 12), XsdDuration(months: 12));
      expect(XsdDuration(months: 12), isNot(XsdDuration(months: 13)));
      expect(
        XsdDuration(seconds: Decimal.fromInt(10)),
        XsdDuration(seconds: Decimal.fromInt(10)),
      );
    });

    test('invalid formats', () {
      expect(() => XsdDuration.parse(''), throwsFormatException);
      expect(() => XsdDuration.parse('1Y'), throwsFormatException); // Missing P
      expect(() => XsdDuration.parse('P'), throwsFormatException); // Empty
      expect(
        () => XsdDuration.parse('P1Y2Y'),
        throwsFormatException,
      ); // Duplicate Y (our parser might actually handle this loosely if we just sum, but strictly it should probably fail or we accept it as sum. The current implementation sums them if they appear in order, but if out of order or duplicate? The current parser is simple sequential. Let's check behavior.)

      // The current parser consumes sequentially. If we have P1Y1Y, it finds first Y, then looks for next.
      // If the string is not fully consumed, it throws.
      // So P1Y1Y: finds 1Y, remaining is 1Y. Next check is M. It won't find M.
      // It continues to D, H, M, S. None found.
      // Finally checks if string is empty. It is not ('1Y'). So it throws. Correct.
      expect(() => XsdDuration.parse('P1Y1Y'), throwsFormatException);

      expect(() => XsdDuration.parse('PT'), throwsFormatException);
      expect(
        () => XsdDuration.parse('P1H'),
        throwsFormatException,
      ); // H needs T
    });

    test('constructor validation', () {
      expect(
        () => XsdDuration(months: 1, seconds: Decimal.fromInt(-1)),
        throwsArgumentError,
      );
      expect(
        () => XsdDuration(months: -1, seconds: Decimal.fromInt(1)),
        throwsArgumentError,
      );
      expect(
        () => XsdDuration(months: 0, seconds: Decimal.fromInt(-1)),
        returnsNormally,
      );
    });

    test('roundtrip', () {
      // Canonical inputs should roundtrip exactly
      final canonicalInputs = [
        'P1Y',
        'P1M',
        'P1D',
        'PT1H',
        'PT1M',
        'PT1S',
        'P1Y1M',
        'P1DT1H',
        'P1Y2M3DT4H5M6.7S',
        '-P1Y',
        'PT0S',
      ];

      for (final input in canonicalInputs) {
        expect(
          XsdDuration.parse(input).toString(),
          input,
          reason: 'Failed to roundtrip canonical input: $input',
        );
      }

      // Non-canonical inputs should normalize to canonical
      final nonCanonicalInputs = {
        'P12M': 'P1Y',
        'PT60S': 'PT1M',
        'PT60M': 'PT1H',
        'PT24H': 'P1D',
        'P0Y': 'PT0S',
        '-PT0S': 'PT0S',
        'P0001Y': 'P1Y', // Leading zeros
      };

      nonCanonicalInputs.forEach((input, expectedCanonical) {
        expect(
          XsdDuration.parse(input).toString(),
          expectedCanonical,
          reason: 'Failed to normalize input: $input',
        );
      });
    });
  });
}
