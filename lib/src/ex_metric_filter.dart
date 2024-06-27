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
