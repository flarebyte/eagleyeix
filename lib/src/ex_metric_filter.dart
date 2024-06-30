import 'ex_abstract_model.dart';
import 'ex_metric_key.dart';
import 'ex_metric_key_value.dart';

/// A filter strategy that checks if the list of doubles is not empty.
class ExNotEmptyPreCond extends ExPreCondition {
  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.isNotEmpty;
  }
}

/// A filter strategy that checks if the list of doubles has more than [threshold] elements.
class ExMoreThanPreCond extends ExPreCondition {
  final int threshold;

  /// Constructs an [ExMoreThanPreCond] instance with the given threshold.
  ExMoreThanPreCond(this.threshold);

  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.length > threshold;
  }
}

/// A filter strategy that checks if the list of doubles has fewer than [threshold] elements.
class ExLessThanPreCond extends ExPreCondition {
  final int threshold;

  /// Constructs an [ExLessThanPreCond] instance with the given threshold.
  ExLessThanPreCond(this.threshold);

  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.length < threshold;
  }
}

/// A filter strategy that checks if the list of doubles has more than or equal to [threshold] elements.
class ExMoreThanOrEqualPreCond extends ExPreCondition {
  final int threshold;

  /// Constructs an [ExMoreThanOrEqualPreCond] instance with the given threshold.
  ExMoreThanOrEqualPreCond(this.threshold);

  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.length >= threshold;
  }
}

/// A filter strategy that checks if the list of doubles has fewer than or equal to [threshold] elements.
class ExLessThanOrEqualPreCond extends ExPreCondition {
  final int threshold;

  /// Constructs an [ExLessThanOrEqualPreCond] instance with the given threshold.
  ExLessThanOrEqualPreCond(this.threshold);

  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.length <= threshold;
  }
}

/// A static utility class for creating various metric filters.
class ExPreConditions {
  /// Creates an [ExMoreThanPreCond] with the given [threshold].
  static ExMoreThanPreCond moreThan(int threshold) {
    return ExMoreThanPreCond(threshold);
  }

  /// Creates an [ExLessThanPreCond] with the given [threshold].
  static ExLessThanPreCond lessThan(int threshold) {
    return ExLessThanPreCond(threshold);
  }

  /// Creates an [ExMoreThanOrEqualPreCond] with the given [threshold].
  static ExMoreThanOrEqualPreCond moreThanOrEqual(int threshold) {
    return ExMoreThanOrEqualPreCond(threshold);
  }

  /// Creates an [ExLessThanOrEqualPreCond] with the given [threshold].
  static ExLessThanOrEqualPreCond lessThanOrEqual(int threshold) {
    return ExLessThanOrEqualPreCond(threshold);
  }

  /// Creates an [ExNotEmptyPreCond].
  static ExNotEmptyPreCond notEmpty() {
    return ExNotEmptyPreCond();
  }
}

/// Class that extends [ExPostCondition] and always returns true for the matches method.
class ExPostCondTrue extends ExPostCondition {
  @override
  bool matches(ExMetricKeyValue keyValue) {
    return true;
  }
}

/// Class that filters by any given dimension.
class ExFilterByAnyDimension extends ExPostCondition {
  /// List of dimensions to filter by.
  final List<String> filterDimensions;

  /// Constructs an [ExFilterByAnyDimension] instance with the given [filterDimensions].
  ExFilterByAnyDimension({
    required this.filterDimensions,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    for (var dimension in filterDimensions) {
      if (keyValue.key.dimensions.containsKey(dimension)) {
        return true;
      }
    }
    return false;
  }
}

/// Class that matches if all given filters match.
class ExPostCondAnd extends ExPostCondition {
  /// List of filters to apply.
  final List<ExPostCondition> filters;

  /// Constructs an [ExPostCondAnd] instance with the given [filters].
  ExPostCondAnd({
    required this.filters,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    for (var filter in filters) {
      if (!filter.matches(keyValue)) {
        return false;
      }
    }
    return true;
  }
}

/// Class that matches if any given filter matches.
class ExPostCondOr extends ExPostCondition {
  /// List of filters to apply.
  final List<ExPostCondition> filters;

  /// Constructs an [ExPostCondOr] instance with the given [filters].
  ExPostCondOr({
    required this.filters,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    for (var filter in filters) {
      if (filter.matches(keyValue)) {
        return true;
      }
    }
    return false;
  }
}

/// Class that matches if the given filter does not match.
class ExPostCondNot extends ExPostCondition {
  /// The filter to apply.
  final ExPostCondition filter;

  /// Constructs an [ExPostCondNot] instance with the given [filter].
  ExPostCondNot({
    required this.filter,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    return !filter.matches(keyValue);
  }
}

/// Class that matches if the value is more than a given threshold.
class ExValueMoreThan extends ExPostCondition {
  /// The threshold value to compare against.
  final double threshold;

  /// Constructs an [ExValueMoreThan] instance with the given [threshold].
  ExValueMoreThan({
    required this.threshold,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    return keyValue.value > threshold;
  }
}

/// Class that matches if the value is less than a given threshold.
class ExValueLessThan extends ExPostCondition {
  /// The threshold value to compare against.
  final double threshold;

  /// Constructs an [ExValueLessThan] instance with the given [threshold].
  ExValueLessThan({
    required this.threshold,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    return keyValue.value < threshold;
  }
}

/// Class that matches if the value is more than or equal to a given threshold.
class ExValueMoreThanOrEqual extends ExPostCondition {
  /// The threshold value to compare against.
  final double threshold;

  /// Constructs an [ExValueMoreThanOrEqual] instance with the given [threshold].
  ExValueMoreThanOrEqual({
    required this.threshold,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    return keyValue.value >= threshold;
  }
}

/// Class that matches if the value is less than or equal to a given threshold.
class ExValueLessThanOrEqual extends ExPostCondition {
  /// The threshold value to compare against.
  final double threshold;

  /// Constructs an [ExValueLessThanOrEqual] instance with the given [threshold].
  ExValueLessThanOrEqual({
    required this.threshold,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    return keyValue.value <= threshold;
  }
}

/// Class that matches if the value is equal to a given threshold.
class ExValueEqual extends ExPostCondition {
  /// The threshold value to compare against.
  final double threshold;

  /// Constructs an [ExValueEqual] instance with the given [threshold].
  ExValueEqual({
    required this.threshold,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    return keyValue.value == threshold;
  }
}

/// A utility class for creating various [ExPostCondition] instances.
class ExPostConditions {
  /// Creates a filter that matches if the value is equal to the given [threshold].
  static ExPostCondition valueEqual(double threshold) {
    return ExValueEqual(threshold: threshold);
  }

  /// Creates a filter that matches if the value is more than the given [threshold].
  static ExPostCondition valueMoreThan(double threshold) {
    return ExValueMoreThan(threshold: threshold);
  }

  /// Creates a filter that matches if the value is less than the given [threshold].
  static ExPostCondition valueLessThan(double threshold) {
    return ExValueLessThan(threshold: threshold);
  }

  /// Creates a filter that matches if the value is more than or equal to the given [threshold].
  static ExPostCondition valueMoreThanOrEqual(double threshold) {
    return ExValueMoreThanOrEqual(threshold: threshold);
  }

  /// Creates a filter that matches if the value is less than or equal to the given [threshold].
  static ExPostCondition valueLessThanOrEqual(double threshold) {
    return ExValueLessThanOrEqual(threshold: threshold);
  }

  /// Creates a filter that matches if any of the given [filters] match.
  static ExPostCondition or(List<ExPostCondition> filters) {
    return ExPostCondOr(filters: filters);
  }

  /// Creates a filter that matches if all of the given [filters] match.
  static ExPostCondition and(List<ExPostCondition> filters) {
    return ExPostCondAnd(filters: filters);
  }

  /// Creates a filter that matches if the given [filter] does not match.
  static ExPostCondition not(ExPostCondition filter) {
    return ExPostCondNot(filter: filter);
  }

  /// Creates a filter that matches if any of the given [dimensions] are present.
  static ExPostCondition filterByAnyDimension(List<String> dimensions) {
    return ExFilterByAnyDimension(filterDimensions: dimensions);
  }

  /// Creates a filter that always matches.
  static ExPostCondition alwaysTrue() {
    return ExPostCondTrue();
  }
}
