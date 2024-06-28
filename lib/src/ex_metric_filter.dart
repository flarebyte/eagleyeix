import 'ex_abstract_model.dart';
import 'ex_metric_key.dart';
import 'ex_metric_key_value.dart';

/// A filter strategy that checks if the list of doubles is not empty.
class ExNotEmptyFilter extends ExMetricFilter {
  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.isNotEmpty;
  }
}

/// A filter strategy that checks if the list of doubles has more than [threshold] elements.
class ExMoreThanFilter extends ExMetricFilter {
  final int threshold;

  /// Constructs an [ExMoreThanFilter] instance with the given threshold.
  ExMoreThanFilter(this.threshold);

  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.length > threshold;
  }
}

/// A filter strategy that checks if the list of doubles has fewer than [threshold] elements.
class ExLessThanFilter extends ExMetricFilter {
  final int threshold;

  /// Constructs an [ExLessThanFilter] instance with the given threshold.
  ExLessThanFilter(this.threshold);

  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.length < threshold;
  }
}

/// A filter strategy that checks if the list of doubles has more than or equal to [threshold] elements.
class ExMoreThanOrEqualFilter extends ExMetricFilter {
  final int threshold;

  /// Constructs an [ExMoreThanOrEqualFilter] instance with the given threshold.
  ExMoreThanOrEqualFilter(this.threshold);

  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.length >= threshold;
  }
}

/// A filter strategy that checks if the list of doubles has fewer than or equal to [threshold] elements.
class ExLessThanOrEqualFilter extends ExMetricFilter {
  final int threshold;

  /// Constructs an [ExLessThanOrEqualFilter] instance with the given threshold.
  ExLessThanOrEqualFilter(this.threshold);

  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) {
    return entry.value.length <= threshold;
  }
}

/// A static utility class for creating various metric filters.
class ExMetricFilters {
  /// Creates an [ExMoreThanFilter] with the given [threshold].
  static ExMoreThanFilter moreThan(int threshold) {
    return ExMoreThanFilter(threshold);
  }

  /// Creates an [ExLessThanFilter] with the given [threshold].
  static ExLessThanFilter lessThan(int threshold) {
    return ExLessThanFilter(threshold);
  }

  /// Creates an [ExMoreThanOrEqualFilter] with the given [threshold].
  static ExMoreThanOrEqualFilter moreThanOrEqual(int threshold) {
    return ExMoreThanOrEqualFilter(threshold);
  }

  /// Creates an [ExLessThanOrEqualFilter] with the given [threshold].
  static ExLessThanOrEqualFilter lessThanOrEqual(int threshold) {
    return ExLessThanOrEqualFilter(threshold);
  }

  /// Creates an [ExNotEmptyFilter].
  static ExNotEmptyFilter notEmpty() {
    return ExNotEmptyFilter();
  }
}

/// Class that extends [ExMetricKeyValueFilter] and always returns true for the matches method.
class ExMetricKeyValueTrue extends ExMetricKeyValueFilter {
  @override
  bool matches(ExMetricKeyValue keyValue) {
    return true;
  }
}

/// Class that filters by any given dimension.
class ExFilterByAnyDimension extends ExMetricKeyValueFilter {
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
class ExMetricKeyValueAnd extends ExMetricKeyValueFilter {
  /// List of filters to apply.
  final List<ExMetricKeyValueFilter> filters;

  /// Constructs an [ExMetricKeyValueAnd] instance with the given [filters].
  ExMetricKeyValueAnd({
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
class ExMetricKeyValueOr extends ExMetricKeyValueFilter {
  /// List of filters to apply.
  final List<ExMetricKeyValueFilter> filters;

  /// Constructs an [ExMetricKeyValueOr] instance with the given [filters].
  ExMetricKeyValueOr({
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
class ExMetricKeyValueNot extends ExMetricKeyValueFilter {
  /// The filter to apply.
  final ExMetricKeyValueFilter filter;

  /// Constructs an [ExMetricKeyValueNot] instance with the given [filter].
  ExMetricKeyValueNot({
    required this.filter,
  });

  @override
  bool matches(ExMetricKeyValue keyValue) {
    return !filter.matches(keyValue);
  }
}

/// Class that matches if the value is more than a given threshold.
class ExValueMoreThan extends ExMetricKeyValueFilter {
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
class ExValueLessThan extends ExMetricKeyValueFilter {
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
class ExValueMoreThanOrEqual extends ExMetricKeyValueFilter {
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
class ExValueLessThanOrEqual extends ExMetricKeyValueFilter {
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
class ExValueEqual extends ExMetricKeyValueFilter {
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

/// A utility class for creating various [ExMetricKeyValueFilter] instances.
class ExMetricKeyValueFilters {
  /// Creates a filter that matches if the value is equal to the given [threshold].
  static ExMetricKeyValueFilter valueEqual(double threshold) {
    return ExValueEqual(threshold: threshold);
  }

  /// Creates a filter that matches if the value is more than the given [threshold].
  static ExMetricKeyValueFilter valueMoreThan(double threshold) {
    return ExValueMoreThan(threshold: threshold);
  }

  /// Creates a filter that matches if the value is less than the given [threshold].
  static ExMetricKeyValueFilter valueLessThan(double threshold) {
    return ExValueLessThan(threshold: threshold);
  }

  /// Creates a filter that matches if the value is more than or equal to the given [threshold].
  static ExMetricKeyValueFilter valueMoreThanOrEqual(double threshold) {
    return ExValueMoreThanOrEqual(threshold: threshold);
  }

  /// Creates a filter that matches if the value is less than or equal to the given [threshold].
  static ExMetricKeyValueFilter valueLessThanOrEqual(double threshold) {
    return ExValueLessThanOrEqual(threshold: threshold);
  }

  /// Creates a filter that matches if any of the given [filters] match.
  static ExMetricKeyValueFilter or(List<ExMetricKeyValueFilter> filters) {
    return ExMetricKeyValueOr(filters: filters);
  }

  /// Creates a filter that matches if all of the given [filters] match.
  static ExMetricKeyValueFilter and(List<ExMetricKeyValueFilter> filters) {
    return ExMetricKeyValueAnd(filters: filters);
  }

  /// Creates a filter that matches if the given [filter] does not match.
  static ExMetricKeyValueFilter not(ExMetricKeyValueFilter filter) {
    return ExMetricKeyValueNot(filter: filter);
  }

  /// Creates a filter that matches if any of the given [dimensions] are present.
  static ExMetricKeyValueFilter filterByAnyDimension(List<String> dimensions) {
    return ExFilterByAnyDimension(filterDimensions: dimensions);
  }

  /// Creates a filter that always matches.
  static ExMetricKeyValueFilter alwaysTrue() {
    return ExMetricKeyValueTrue();
  }
}
