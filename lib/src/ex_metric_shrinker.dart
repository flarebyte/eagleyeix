import 'dart:math';

import 'package:eagleyeix/src/ex_abstract_model.dart';

/// Class that implements ExMetricDoubleShrinker and applies a logarithmic
/// transformation based on a specified base.
class ExMetricLogShrinker implements ExMetricDoubleShrinker {
  final int base;
  final int start;

  /// Constructor to initialize the base and start fields.
  ExMetricLogShrinker({
    required this.base,
    required this.start,
  }) {
    if (base <= 1) {
      throw ArgumentError(
          'Base must be greater than one for logarithmic transformation.');
    }
  }

  @override
  double shrink(double value) {
    if (value <= 0) {
      throw ArgumentError(
          'Value must be greater than zero for logarithmic transformation.');
    }

    // Calculate the logarithmic value and truncate it to an integer.
    double logValue = log(value) / log(base);
    int truncatedLogValue = logValue.floor();

    // Return the result adding the start value.
    return (start + truncatedLogValue).toDouble();
  }
}

/// Class that implements ExMetricDoubleShrinker and returns the given value.
class ExMetricPassShrinker implements ExMetricDoubleShrinker {
  @override
  double shrink(double value) {
    return value;
  }
}

/// Class that implements ExMetricDoubleShrinker and returns the floor value plus the start.
class ExMetricFloorShrinker implements ExMetricDoubleShrinker {
  final int start;

  /// Constructor to initialize the start field.
  ExMetricFloorShrinker({required this.start});

  @override
  double shrink(double value) {
    return (start + value.floor()).toDouble();
  }
}

/// Class that implements ExMetricDoubleShrinker and returns the ceiling value plus the start.
class ExMetricCeilShrinker implements ExMetricDoubleShrinker {
  final int start;

  /// Constructor to initialize the start field.
  ExMetricCeilShrinker({required this.start});

  @override
  double shrink(double value) {
    return (start + value.ceil()).toDouble();
  }
}

/// Static class that provides factory methods for creating instances
/// of different ExMetricDoubleShrinker implementations.
class ExMetricDoubleShrinkers {
  /// Factory method to create an instance of ExMetricLogShrinker.
  static ExMetricLogShrinker log({required int base, required int start}) {
    return ExMetricLogShrinker(base: base, start: start);
  }

  /// Factory method to create an instance of ExMetricPassShrinker.
  static ExMetricPassShrinker pass() {
    return ExMetricPassShrinker();
  }

  /// Factory method to create an instance of ExMetricFloorShrinker.
  static ExMetricFloorShrinker floor({required int start}) {
    return ExMetricFloorShrinker(start: start);
  }

  /// Factory method to create an instance of ExMetricCeilShrinker.
  static ExMetricCeilShrinker ceil({required int start}) {
    return ExMetricCeilShrinker(start: start);
  }
}
