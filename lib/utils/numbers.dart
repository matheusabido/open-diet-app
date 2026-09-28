String formatAmount(double amount) {
  if (amount.truncate() != amount) {
    return amount.toString();
  }
  return amount.truncate().toString();
}
