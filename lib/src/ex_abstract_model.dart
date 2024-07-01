import 'ex_metric_key.dart';
import 'ex_metric_key_value.dart';

/// Abstract class representing a metric aggregation strategy.
/// Provides a method for aggregating metrics.
abstract class ExMetricAggregation {
  /// Aggregates a map entry of [ExMetricKey] and [double[]] and returns a list of [ExMetricKeyValue].
  List<ExMetricKeyValue> aggregate(MapEntry<ExMetricKey, List<double>> entry);
}

/// Abstract class for a metric filter strategy.
abstract class ExPreCondition {
  bool matches(MapEntry<ExMetricKey, List<double>> entry);
}

/// Abstract class for a key value metric filter strategy.
abstract class ExPostCondition {
  bool matches(ExMetricKeyValue keyValue);
}

/// Abstract class for the shrinking the range of a metric.
abstract class ExMetricDoubleShrinker {
  double shrink(double value);
}
