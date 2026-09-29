const _definitions = {
  'g': (dimension: 'mass', toBase: 1.0),
  'kg': (dimension: 'mass', toBase: 1000.0),
  'mg': (dimension: 'mass', toBase: 0.001),
  'oz': (dimension: 'mass', toBase: 28.349523125),
  'lb': (dimension: 'mass', toBase: 453.59237),
  'ml': (dimension: 'volume', toBase: 1.0),
  'L': (dimension: 'volume', toBase: 1000.0),
  'dL': (dimension: 'volume', toBase: 100.0),
  'un': (dimension: 'count', toBase: 1.0),
};

double convertUnit(double amount, String from, String to) {
  return amount * _definitions[from]!.toBase / _definitions[to]!.toBase;
}

List<String> compatibleUnits(String unit) {
  final dimension = _definitions[unit]!.dimension;
  return _definitions.keys
      .where((other) => _definitions[other]!.dimension == dimension)
      .toList();
}
