/// Builds an international phone number (E.164, e.g. "+34600000001")
/// from what the user typed. Returns null if it doesn't look valid.
///
/// Accepts spaces, dashes and dots ("600 00 00 01", "600-000-001").
String? normalizePhone({required String prefix, required String number}) {
  final prefixDigits = prefix.replaceAll(RegExp(r'\D'), '');
  var digits = number.replaceAll(RegExp(r'\D'), '');
  if (prefixDigits.isEmpty || digits.isEmpty) return null;

  // People sometimes type the prefix again in the number ("34 600...").
  if (digits.startsWith(prefixDigits) && digits.length > 9) {
    digits = digits.substring(prefixDigits.length);
  }
  final full = '$prefixDigits$digits';
  // E.164: at most 15 digits. Spanish numbers have 9 after +34.
  if (digits.length < 6 || full.length > 15) return null;
  if (prefixDigits == '34' && digits.length != 9) return null;
  return '+$full';
}

/// "+34600000001" → "+34 600 000 001", easier to read.
String formatPhone(String e164) {
  if (e164.startsWith('+34') && e164.length == 12) {
    final n = e164.substring(3);
    return '+34 ${n.substring(0, 3)} ${n.substring(3, 6)} ${n.substring(6)}';
  }
  return e164;
}
