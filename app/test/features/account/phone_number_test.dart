import 'package:app/features/account/data/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizePhone', () {
    test('Spanish number with spaces', () {
      expect(normalizePhone(prefix: '+34', number: '600 00 00 01'), '+34600000001');
    });

    test('dashes, dots and a prefix typed twice are fine', () {
      expect(normalizePhone(prefix: '34', number: '600-000.001'), '+34600000001');
      expect(normalizePhone(prefix: '+34', number: '34 600 000 001'), '+34600000001');
    });

    test('Spanish numbers need 9 digits', () {
      expect(normalizePhone(prefix: '+34', number: '60000001'), isNull);
      expect(normalizePhone(prefix: '+34', number: '6000000011'), isNull);
    });

    test('other countries: up to 15 digits in total', () {
      expect(normalizePhone(prefix: '+52', number: '55 1234 5678'), '+525512345678');
      expect(normalizePhone(prefix: '+52', number: '1234567890123456'), isNull);
    });

    test('empty input is rejected', () {
      expect(normalizePhone(prefix: '+34', number: ''), isNull);
      expect(normalizePhone(prefix: '', number: '600000001'), isNull);
    });
  });

  test('formatPhone groups Spanish numbers', () {
    expect(formatPhone('+34600000001'), '+34 600 000 001');
    expect(formatPhone('+525512345678'), '+525512345678');
  });
}
