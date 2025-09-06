import 'package:test/test.dart';
import 'package:xsd/src/codecs/nmtoken/nmtoken_codec.dart';

void main() {
  group('XsdNmtokenCodec', () {
    const codec = xsdNmtokenCodec;

    group('decoder', () {
      test('should decode a valid NMTOKEN string', () {
        expect(codec.decode('valid-nmtoken_1.2:3'), 'valid-nmtoken_1.2:3');
        expect(codec.decode('12345'), '12345');
        expect(codec.decode('.start'), '.start');
        expect(codec.decode('עם-שלום'), 'עם-שלום'); // Unicode example
      });

      // Source: https://github.com/w3c/xsdtests/tree/master/nistData/atomic/NMTOKEN
      test('should decode NIST provided examples', () {
        expect(codec.decode('under.the_digital-among-calle'), 'under.the_digital-among-calle');
        expect(codec.decode('and_is_that_use:issues:data.t'), 'and_is_that_use:issues:data.t');
        expect(codec.decode('is-OASIS.of_related_wide-file'), 'is-OASIS.of_related_wide-file');
        expect(codec.decode('and_and-design-defines_first_'), 'and_and-design-defines_first_');
        expect(codec.decode('and_operating:and.effectively'), 'and_operating:and.effectively');
        expect(codec.decode('Internet_will:_that:to_mad'), 'Internet_will:_that:to_mad');
        expect(codec.decode('launching.correctness_revisions_and.sp'), 'launching.correctness_revisions_and.sp');
        expect(codec.decode('computing-NSRL.can:a.to-of:must-perv'), 'computing-NSRL.can:a.to-of:must-perv');
        expect(codec.decode('that.cost_Business-for_are:industries:processes_pico-'), 'that.cost_Business-for_are:industries:processes_pico-');
        expect(codec.decode('collaborate-tools-we_with.each.the_relationships_networ'), 'collaborate-tools-we_with.each.the_relationships_networ');
        expect(codec.decode('led:back:must.ITL_applications:excha'), 'led:back:must.ITL_applications:excha');
        expect(codec.decode('and-software.help.be:shift:offer.DOM.working.automate:Co'), 'and-software.help.be:shift:offer.DOM.working.automate:Co');
        expect(codec.decode('cost:on:and_available-will.to:must.tune:creati'), 'cost:on:and_available-will.to:must.tune:creati');
        expect(codec.decode('as:test-Markup-supply.transactions_for_Standards.for-with.sig'), 'as:test-Markup-supply.transactions_for_Standards.for-with.sig');
        expect(codec.decode('outfitting.donat'), 'outfitting.donat');
        expect(codec.decode('working.solve-'), 'working.solve-');
        expect(codec.decode('and-to:Simulation:pro'), 'and-to:Simulation:pro');
        expect(codec.decode('needed:as-is.Furthermore_retrieve-to.means.find'), 'needed:as-is.Furthermore_retrieve-to.means.find');
        expect(codec.decode('the_United-development-and-each-disco'), 'the_United-development-and-each-disco');
        expect(codec.decode('Groups_in_'), 'Groups_in_');
        expect(codec.decode('industry:Advancement.permitting_conformance.and_will-partici'), 'industry:Advancement.permitting_conformance.and_will-partici');
        expect(codec.decode('than:business:ebXML-of:for.of_electronic.diagnosti'), 'than:business:ebXML-of:for.of_electronic.diagnosti');
        expect(codec.decode('manual.that.tools.standard'), 'manual.that.tools.standard');
        expect(codec.decode('discover.OASIS-versions.has.compatibility-embedded'), 'discover.OASIS-versions.has.compatibility-embedded');
        expect(codec.decode('browsers:DOM:both.chain:the:recommending.C'), 'browsers:DOM:both.chain:the:recommending.C');
        expect(codec.decode('methods.profiles.ensure_manipulate.b'), 'methods.profiles.ensure_manipulate.b');
        expect(codec.decode('criteria:-must-tar'), 'criteria:-must-tar');
        expect(codec.decode('trans'), 'trans');
        expect(codec.decode('Objec'), 'Objec');
        expect(codec.decode('must_Investigators_signatures:tools_software-to.that-as:ro'), 'must_Investigators_signatures:tools_software-to.that-as:ro');
        expect(codec.decode('that_profiles:defi'), 'that_profiles:defi');
        expect(codec.decode('related_implementation-security.capabilities:that'), 'related_implementation-security.capabilities:that');
        expect(codec.decode('The-of_files.for.Recommendation-appropriate-disco'), 'The-of_files.for.Recommendation-appropriate-disco');
        expect(codec.decode('cross-over.related.ambiguities-The.Ex'), 'cross-over.related.ambiguities-The.Ex');
        expect(codec.decode('via.discussions'), 'via.discussions');
        expect(codec.decode('have_automatic'), 'have_automatic');
        expect(codec.decode('prominent_retrieve_rigorous.a:of-for.define-and:participants:Ja'), 'prominent_retrieve_rigorous.a:of-for.define-and:participants:Ja');
        expect(codec.decode('only:d'), 'only:d');
        expect(codec.decode('object_rapid.of:partners:including.docume'), 'object_rapid.of:partners:including.docume');
        expect(codec.decode('define.a:Schemas-OASIS:working.Conference_profi'), 'define.a:Schemas-OASIS:working.Conference_profi');
      });

      test('should collapse whitespace before validation', () {
        expect(codec.decode('  \n valid-nmtoken\t  '), 'valid-nmtoken');
      });

      test('should throw FormatException for strings with internal spaces', () {
        expect(() => codec.decode('invalid nmtoken'), throwsFormatException);
      });

      test(
        'should throw FormatException for empty or whitespace-only strings',
        () {
          expect(() => codec.decode(''), throwsFormatException);
          expect(() => codec.decode('   \t\n '), throwsFormatException);
        },
      );

      test('should throw FormatException for invalid characters', () {
        expect(() => codec.decode('invalid!'), throwsFormatException);
        expect(() => codec.decode('in/valid'), throwsFormatException);
        expect(() => codec.decode('in,valid'), throwsFormatException);
      });
    });

    group('encoder', () {
      test('should encode a valid NMTOKEN string', () {
        expect(codec.encode('valid-nmtoken_1.2:3'), 'valid-nmtoken_1.2:3');
        expect(codec.encode('עם-שלום'), 'עם-שלום');
      });

      test('should throw FormatException for strings with any whitespace', () {
        expect(() => codec.encode('invalid nmtoken'), throwsFormatException);
        expect(() => codec.encode(' leading-space'), throwsFormatException);
        expect(() => codec.encode('trailing-space '), throwsFormatException);
      });

      test('should throw FormatException for empty strings', () {
        expect(() => codec.encode(''), throwsFormatException);
      });

      test('should throw FormatException for invalid characters', () {
        expect(() => codec.encode('invalid!'), throwsFormatException);
        expect(() => codec.encode('in/valid'), throwsFormatException);
        expect(() => codec.encode('in,valid'), throwsFormatException);
      });

      // Source: https://github.com/w3c/xsdtests/tree/master/nistData/atomic/NMTOKEN
      test('should encode NIST provided examples', () {
        expect(codec.encode('under.the_digital-among-calle'), 'under.the_digital-among-calle');
        expect(codec.encode('and_is_that_use:issues:data.t'), 'and_is_that_use:issues:data.t');
        expect(codec.encode('is-OASIS.of_related_wide-file'), 'is-OASIS.of_related_wide-file');
        expect(codec.encode('and_and-design-defines_first_'), 'and_and-design-defines_first_');
        expect(codec.encode('and_operating:and.effectively'), 'and_operating:and.effectively');
        expect(codec.encode('Internet_will:_that:to_mad'), 'Internet_will:_that:to_mad');
        expect(codec.encode('launching.correctness_revisions_and.sp'), 'launching.correctness_revisions_and.sp');
        expect(codec.encode('computing-NSRL.can:a.to-of:must-perv'), 'computing-NSRL.can:a.to-of:must-perv');
        expect(codec.encode('that.cost_Business-for_are:industries:processes_pico-'), 'that.cost_Business-for_are:industries:processes_pico-');
        expect(codec.encode('collaborate-tools-we_with.each.the_relationships_networ'), 'collaborate-tools-we_with.each.the_relationships_networ');
        expect(codec.encode('led:back:must.ITL_applications:excha'), 'led:back:must.ITL_applications:excha');
        expect(codec.encode('and-software.help.be:shift:offer.DOM.working.automate:Co'), 'and-software.help.be:shift:offer.DOM.working.automate:Co');
        expect(codec.encode('cost:on:and_available-will.to:must.tune:creati'), 'cost:on:and_available-will.to:must.tune:creati');
        expect(codec.encode('as:test-Markup-supply.transactions_for_Standards.for-with.sig'), 'as:test-Markup-supply.transactions_for_Standards.for-with.sig');
        expect(codec.encode('outfitting.donat'), 'outfitting.donat');
        expect(codec.encode('working.solve-'), 'working.solve-');
        expect(codec.encode('and-to:Simulation:pro'), 'and-to:Simulation:pro');
        expect(codec.encode('needed:as-is.Furthermore_retrieve-to.means.find'), 'needed:as-is.Furthermore_retrieve-to.means.find');
        expect(codec.encode('the_United-development-and-each-disco'), 'the_United-development-and-each-disco');
        expect(codec.encode('Groups_in_'), 'Groups_in_');
        expect(codec.encode('industry:Advancement.permitting_conformance.and_will-partici'), 'industry:Advancement.permitting_conformance.and_will-partici');
        expect(codec.encode('than:business:ebXML-of:for.of_electronic.diagnosti'), 'than:business:ebXML-of:for.of_electronic.diagnosti');
        expect(codec.encode('manual.that.tools.standard'), 'manual.that.tools.standard');
        expect(codec.encode('discover.OASIS-versions.has.compatibility-embedded'), 'discover.OASIS-versions.has.compatibility-embedded');
        expect(codec.encode('browsers:DOM:both.chain:the:recommending.C'), 'browsers:DOM:both.chain:the:recommending.C');
        expect(codec.encode('methods.profiles.ensure_manipulate.b'), 'methods.profiles.ensure_manipulate.b');
        expect(codec.encode('criteria:-must-tar'), 'criteria:-must-tar');
        expect(codec.encode('trans'), 'trans');
        expect(codec.encode('Objec'), 'Objec');
        expect(codec.encode('must_Investigators_signatures:tools_software-to.that-as:ro'), 'must_Investigators_signatures:tools_software-to.that-as:ro');
        expect(codec.encode('that_profiles:defi'), 'that_profiles:defi');
        expect(codec.encode('related_implementation-security.capabilities:that'), 'related_implementation-security.capabilities:that');
        expect(codec.encode('The-of_files.for.Recommendation-appropriate-disco'), 'The-of_files.for.Recommendation-appropriate-disco');
        expect(codec.encode('cross-over.related.ambiguities-The.Ex'), 'cross-over.related.ambiguities-The.Ex');
        expect(codec.encode('via.discussions'), 'via.discussions');
        expect(codec.encode('have_automatic'), 'have_automatic');
        expect(codec.encode('prominent_retrieve_rigorous.a:of-for.define-and:participants:Ja'), 'prominent_retrieve_rigorous.a:of-for.define-and:participants:Ja');
        expect(codec.encode('only:d'), 'only:d');
        expect(codec.encode('object_rapid.of:partners:including.docume'), 'object_rapid.of:partners:including.docume');
        expect(codec.encode('define.a:Schemas-OASIS:working.Conference_profi'), 'define.a:Schemas-OASIS:working.Conference_profi');
      });
    });
  });
}
