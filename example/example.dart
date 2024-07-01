import 'dart:convert';
import 'dart:math';

import 'package:eagleyeix/metric.dart';

/// A simple example of metrics.
class AppMetrics {
  static final create = ExMetricKey(name: [
    'eagleyeix',
    'example',
    'create'
  ], dimensions: {
    ExMetricDimStatus.key: ExMetricDimStatus.found,
    ExMetricDimUnit.key: ExMetricDimUnit.count
  });
  static final random = ExMetricKey(
      name: ['eagleyeix', 'example', 'random'],
      dimensions: {ExMetricDimUnit.key: ExMetricDimUnit.bytes});
}

void main() {
  // Create random metrics just for exxamples.
  var random = Random();

  // Create a metric store and add some metrics to it
  final store = ExMetricStoreHolder().store;

  // Add twice one hundred metrics to the store
  for (int _ in Iterable.generate(100)) {
    store.addMetric(AppMetrics.create, 1);
    store.addMetric(AppMetrics.random, random.nextInt(50).toDouble());
  }

  // Create a condition that checks if the unit is count
  final ifCount = ExPostConditions.and([
    ExPostConditions.valueMoreThan(0),
    ExPostConditions.filterByAnyDimension(
        {ExMetricDimUnit.key: ExMetricDimUnit.count})
  ]);

  // Create two aggregations, once that does a count and the other that does a median
  final aggregations = ExMetricAggregations.list([
    // Count the metrics that are count unit and shrink it by logarithm
    ExMetricAggregations.count(
        postCondition: ifCount, shrinker: ExMetricDoubleShrinkers.log(base: 2)),
    // Median the metrics that are not count unit and round them to the ceiling
    ExMetricAggregations.median(
        postCondition: ExPostConditions.not(ifCount),
        shrinker: ExMetricDoubleShrinkers.ceil())
  ]);

  // Aggregate all metrics in the store and print them
  final stats = store.aggregateAll(aggregations);
  print(jsonEncode(stats));
  // [
  // {"key":{"name":["eagleyeix","example","create"],"dimensions":{"status":"found","unit":"count","aggregation":"count"}},"value":6.0},
  // {"key":{"name":["eagleyeix","example","random"],"dimensions":{"unit":"bytes","aggregation":"median"}},"value":24.0}
  //]
}
