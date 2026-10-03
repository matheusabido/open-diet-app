String formatAmount(double amount) {
  if (amount.truncate() != amount) {
    return amount.toString();
  }
  return amount.truncate().toString();
}

String formatRounded(double value) {
  return formatAmount((value * 10).round() / 10);
}
