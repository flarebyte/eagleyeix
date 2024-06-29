import 'ex_abstract_model.dart';
import 'ex_metric_filter.dart';
import 'ex_metric_key.dart';
import 'ex_metric_key_value.dart';
import 'ex_metric_shrinker.dart';

mixin ExMetricFilterMixin {
  late final ExMetricFilter preCondition;
  late final ExMetricKeyValueFilter postCondition;
  late final ExMetricDoubleShrinker shrinker;
  late final Map<String, String> additionalDimensions;

  bool applyPreCondition(MapEntry<ExMetricKey, List<double>> entry) {
    return preCondition.matches(entry);
  }

  List<ExMetricKeyValue> applyPostCondition(List<ExMetricKeyValue> keyValues) {
    return keyValues.where(postCondition.matches).toList();
  }

  ExMetricKey addDimensions(
      ExMetricKey key, Map<String, String> additionalDimensions) {
    final updatedDimensions = Map<String, String>.from(key.dimensions)
      ..addAll(additionalDimensions);
    return ExMetricKey(name: key.name, dimensions: updatedDimensions);
  }

  double applyShrinker(double value) {
    return shrinker.shrink(value);
  }

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

class ExMetricAggregations {
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
}
