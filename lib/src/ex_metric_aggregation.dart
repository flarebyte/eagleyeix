import 'ex_abstract_model.dart';
import 'ex_metric_filter.dart';
import 'ex_metric_key.dart';
import 'ex_metric_key_value.dart';
import 'ex_metric_shrinker.dart';

/// Mixin for applying metric pre conditions, post conditions and metric shrinkers
mixin ExMetricFilterMixin {
  late final ExMetricFilter preCondition;
  late final ExMetricKeyValueFilter postCondition;
  late final ExMetricDoubleShrinker shrinker;
  late final Map<String, String> additionalDimensions;

  /// Applies the metric pre condition to the given entry
  bool applyPreCondition(MapEntry<ExMetricKey, List<double>> entry) {
    return preCondition.matches(entry);
  }

  /// Applies the metric post condition to the given list of entries
  List<ExMetricKeyValue> applyPostCondition(List<ExMetricKeyValue> keyValues) {
    return keyValues.where(postCondition.matches).toList();
  }

  /// Add a dimension to the given metric (ex: 'country' => 'US')
  ExMetricKey addDimensions(
      ExMetricKey key, Map<String, String> additionalDimensions) {
    final updatedDimensions = Map<String, String>.from(key.dimensions)
      ..addAll(additionalDimensions);
    return ExMetricKey(name: key.name, dimensions: updatedDimensions);
  }

  /// Applies the metric shrinker to the given value
  double applyShrinker(double value) {
    return shrinker.shrink(value);
  }

  /// Aggregates the given metric values. In other words, it takes the given metric values and returns a single value.
  List<ExMetricKeyValue> aggregateMetric(
      MapEntry<ExMetricKey, List<double>> entry,
      double Function(List<double>) aggregator,
      Map<String, String> aggregationDimension) {
    if (!applyPreCondition(entry)) {
      return [];
    }

    final aggregateValue = aggregator(entry.value);
    final shrunkValue = applyShrinker(aggregateValue);
    final keyWithDimensions = addDimensions(
        entry.key, {...additionalDimensions, ...aggregationDimension});
    final keyValue =
        ExMetricKeyValue(key: keyWithDimensions, value: shrunkValue);

    return applyPostCondition([keyValue]);
  }
}

/// A metric that counts the number of entries.
class ExMetricCount extends ExMetricAggregation with ExMetricFilterMixin {
  ExMetricCount({
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    this.preCondition = preCondition ?? ExMetricFilters.notEmpty();
    this.postCondition = postCondition ?? ExMetricKeyValueFilters.alwaysTrue();
    this.shrinker = shrinker ?? ExMetricDoubleShrinkers.pass();
    this.additionalDimensions = additionalDimensions ?? {};
  }

  @override
  List<ExMetricKeyValue> aggregate(MapEntry<ExMetricKey, List<double>> entry) {
    return aggregateMetric(
      entry,
      (values) => values.length.toDouble(),
      {'aggregation': 'count'},
    );
  }
}

/// A metric that sums the entries.
class ExMetricSum extends ExMetricAggregation with ExMetricFilterMixin {
  ExMetricSum({
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    this.preCondition = preCondition ?? ExMetricFilters.notEmpty();
    this.postCondition = postCondition ?? ExMetricKeyValueFilters.alwaysTrue();
    this.shrinker = shrinker ?? ExMetricDoubleShrinkers.pass();
    this.additionalDimensions = additionalDimensions ?? {};
  }

  @override
  List<ExMetricKeyValue> aggregate(MapEntry<ExMetricKey, List<double>> entry) {
    return aggregateMetric(
      entry,
      (values) => values.fold(0.0, (prev, element) => prev + element),
      {'aggregation': 'sum'},
    );
  }
}

/// A metric that averages the entries.
class ExMetricAvg extends ExMetricAggregation with ExMetricFilterMixin {
  ExMetricAvg({
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    this.preCondition = preCondition ?? ExMetricFilters.notEmpty();
    this.postCondition = postCondition ?? ExMetricKeyValueFilters.alwaysTrue();
    this.shrinker = shrinker ?? ExMetricDoubleShrinkers.pass();
    this.additionalDimensions = additionalDimensions ?? {};
  }

  @override
  List<ExMetricKeyValue> aggregate(MapEntry<ExMetricKey, List<double>> entry) {
    return aggregateMetric(
      entry,
      (values) =>
          values.isEmpty ? 0.0 : values.reduce((a, b) => a + b) / values.length,
      {'aggregation': 'average'},
    );
  }
}

/// A metric that returns the median of the entries.
class ExMetricMedian extends ExMetricAggregation with ExMetricFilterMixin {
  ExMetricMedian({
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    this.preCondition = preCondition ?? ExMetricFilters.notEmpty();
    this.postCondition = postCondition ?? ExMetricKeyValueFilters.alwaysTrue();
    this.shrinker = shrinker ?? ExMetricDoubleShrinkers.pass();
    this.additionalDimensions = additionalDimensions ?? {};
  }

  @override
  List<ExMetricKeyValue> aggregate(MapEntry<ExMetricKey, List<double>> entry) {
    return aggregateMetric(
      entry,
      (values) {
        if (values.isEmpty) return 0.0;
        final sortedValues = List<double>.from(values)..sort();
        final mid = sortedValues.length ~/ 2;
        if (sortedValues.length % 2 == 1) {
          return sortedValues[mid];
        } else {
          return (sortedValues[mid - 1] + sortedValues[mid]) / 2.0;
        }
      },
      {'aggregation': 'median'},
    );
  }
}

/// A metric that returns the quantile of the entries.
class ExMetricQuantile extends ExMetricAggregation with ExMetricFilterMixin {
  final double quantile;

  ExMetricQuantile({
    required this.quantile,
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    assert(
        quantile >= 0.0 && quantile <= 1.0, 'Quantile must be between 0 and 1');
    this.preCondition = preCondition ?? ExMetricFilters.notEmpty();
    this.postCondition = postCondition ?? ExMetricKeyValueFilters.alwaysTrue();
    this.shrinker = shrinker ?? ExMetricDoubleShrinkers.pass();
    this.additionalDimensions = additionalDimensions ?? {};
  }

  @override
  List<ExMetricKeyValue> aggregate(MapEntry<ExMetricKey, List<double>> entry) {
    return aggregateMetric(
      entry,
      (values) {
        if (values.isEmpty) return 0.0;
        final sortedValues = List<double>.from(values)..sort();
        final n = sortedValues.length;
        final position = quantile * n;
        final index = position.floor() - 1;

        if (index < 0) {
          return sortedValues.first;
        } else if (index >= n - 1) {
          return sortedValues.last;
        } else {
          final lowerValue = sortedValues[index];
          final upperValue = sortedValues[index + 1];
          return (lowerValue + upperValue) / 2.0;
        }
      },
      {'aggregation': 'quantile', 'quantile': quantile.toString()},
    );
  }
}

/// Class that applies multiple ExMetricAggregation strategies to a given entry
/// and flattens the results.
class ExMetricList extends ExMetricAggregation {
  final List<ExMetricAggregation> aggregations;

  /// Constructs an ExMetricList with a list of ExMetricAggregation strategies.
  ExMetricList(this.aggregations);

  /// Aggregates the given entry using all provided aggregation strategies and
  /// flattens the results into a single list of ExMetricKeyValue.
  @override
  List<ExMetricKeyValue> aggregate(MapEntry<ExMetricKey, List<double>> entry) {
    List<ExMetricKeyValue> results = [];

    for (var aggregation in aggregations) {
      results.addAll(aggregation.aggregate(entry));
    }

    return results;
  }
}

/// Sugar syntax for constructing aggregations.
class ExMetricAggregations {
  /// Sums the values of a metric.
  static ExMetricSum sum({
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    return ExMetricSum(
      preCondition: preCondition,
      postCondition: postCondition,
      shrinker: shrinker,
      additionalDimensions: additionalDimensions,
    );
  }

  ///
  static ExMetricCount count({
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    return ExMetricCount(
      preCondition: preCondition,
      postCondition: postCondition,
      shrinker: shrinker,
      additionalDimensions: additionalDimensions,
    );
  }

  /// Averages the values of a metric.
  static ExMetricAvg average({
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    return ExMetricAvg(
      preCondition: preCondition,
      postCondition: postCondition,
      shrinker: shrinker,
      additionalDimensions: additionalDimensions,
    );
  }

  /// Median of the values of a metric.
  static ExMetricMedian median({
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    return ExMetricMedian(
      preCondition: preCondition,
      postCondition: postCondition,
      shrinker: shrinker,
      additionalDimensions: additionalDimensions,
    );
  }

  /// Quantile of the values of a metric.
  static ExMetricQuantile quantile({
    required double quantile,
    ExMetricFilter? preCondition,
    ExMetricKeyValueFilter? postCondition,
    ExMetricDoubleShrinker? shrinker,
    Map<String, String>? additionalDimensions,
  }) {
    return ExMetricQuantile(
      quantile: quantile,
      preCondition: preCondition,
      postCondition: postCondition,
      shrinker: shrinker,
      additionalDimensions: additionalDimensions,
    );
  }

  /// Creates an ExMetricList instance with the provided set of ExMetricAggregation strategies.
  static ExMetricList list(List<ExMetricAggregation> aggregations) {
    return ExMetricList(aggregations);
  }
}
