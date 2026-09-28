String formatErrors(
  Map<String, List<String>> errors,
  Map<String, String> labels,
) {
  return errors.entries
      .map((entry) {
        final label = labels[entry.key] ?? entry.key;
        return '$label ${entry.value.join(', ')}';
      })
      .join('\n');
}
