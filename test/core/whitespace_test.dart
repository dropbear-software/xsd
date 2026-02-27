import 'package:test/test.dart';
import 'package:xsd/src/core/whitespace.dart';

void main() {
  group('XsdWhitespace', () {
    group('preserve', () {
      test('does not change input', () {
        expect(
          normalizeWhitespace('''
  abc  
  def  ''', XsdWhitespace.preserve),
          '''
  abc  
  def  ''',
        );
      });
    });

    group('replace', () {
      test('replaces tabs, line feeds, and carriage returns with spaces', () {
        expect(
          normalizeWhitespace('abc\tdef', XsdWhitespace.replace),
          'abc def',
        );
        expect(
          normalizeWhitespace('abc\ndef', XsdWhitespace.replace),
          'abc def',
        );
        expect(
          normalizeWhitespace('abc\rdef', XsdWhitespace.replace),
          'abc def',
        );
      });
    });

    group('collapse', () {
      test(
        'replaces whitespace with spaces, collapses contiguous spaces, and removes ends',
        () {
          expect(
            normalizeWhitespace('''
  abc  
  def  ''', XsdWhitespace.collapse),
            'abc def',
          );
          expect(
            normalizeWhitespace('''
\t\n \r''', XsdWhitespace.collapse),
            '',
          );
        },
      );

      test('preserves non-XSD whitespace like non-breaking space (U+00A0)', () {
        // U+00A0 is whitespace in many systems, but NOT in XSD whiteSpace logic.
        const nbsp = '\u00A0';
        expect(
          normalizeWhitespace('$nbsp abc $nbsp', XsdWhitespace.collapse),
          '$nbsp abc $nbsp',
        );
      });
    });
  });
}
