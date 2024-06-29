import 'dart:math';

import 'package:eagleyeix/src/ex_abstract_model.dart';

/// Class that implements ExMetricDoubleShrinker and applies a logarithmic
/// transformation based on a specified base.
class ExMetricLogShrinker implements ExMetricDoubleShrinker {
  late final int base;
  late final int start;

  /// Constructor to initialize the base and start fields.
  ExMetricLogShrinker({
    int? base,
    int? start,
  }) {
    this.base = base ?? 10;
    this.start = start ?? 0;
    if (this.base <= 1) {
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
  late final int start;

  /// Constructor to initialize the start field.
  ExMetricFloorShrinker({int? start}) {
    this.start = start ?? 0;
  }

  @override
  double shrink(double value) {
    return (start + value.floor()).toDouble();
  }
}

/// Class that implements ExMetricDoubleShrinker and returns the ceiling value plus the start.
class ExMetricCeilShrinker implements ExMetricDoubleShrinker {
  late final int start;

  /// Constructor to initialize the start field.
  ExMetricCeilShrinker({int? start}) {
    this.start = start ?? 0;
  }

  @override
  double shrink(double value) {
    return (start + value.ceil()).toDouble();
  }
}

/// Static class that provides factory methods for creating instances
/// of different ExMetricDoubleShrinker implementations.
class ExMetricDoubleShrinkers {
  /// Factory method to create an instance of ExMetricLogShrinker.
  static ExMetricLogShrinker log({int? base, int? start}) {
    return ExMetricLogShrinker(base: base, start: start);
  }

  /// Factory method to create an instance of ExMetricPassShrinker.
  static ExMetricPassShrinker pass() {
    return ExMetricPassShrinker();
  }

  /// Factory method to create an instance of ExMetricFloorShrinker.
  static ExMetricFloorShrinker floor({int? start}) {
    return ExMetricFloorShrinker(start: start);
  }

  /// Factory method to create an instance of ExMetricCeilShrinker.
  static ExMetricCeilShrinker ceil({int? start}) {
    return ExMetricCeilShrinker(start: start);
  }
}
