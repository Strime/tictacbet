/// Currency formatting extensions.
extension CurrencyFormatter on int {
  /// Formats as currency string: `$5` for 5, `$0` for 0.
  String toCurrency() => '\$$this';

  /// Formats with sign: `+$10` for 10, `-$3` for -3, `$0` for 0.
  String toSignedCurrency() {
    if (this > 0) return '+\$$this';
    if (this < 0) return '-\$${abs()}';
    return '\$0';
  }
}
