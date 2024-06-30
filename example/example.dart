import 'dart:convert';
import 'dart:math';

import 'package:eagleyeix/metric.dart';

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
  var random = Random();

  final store = ExMetricStoreHolder().store;
  for (int _ in Iterable.generate(100)) {
    store.addMetric(AppMetrics.create, 1);
    store.addMetric(AppMetrics.random, random.nextInt(50).toDouble());
  }
  final ifCount = ExPostConditions.and([
    ExPostConditions.valueMoreThan(0),
    ExPostConditions.filterByAnyDimension(
        {ExMetricDimUnit.key: ExMetricDimUnit.count})
  ]);

  final aggregations = ExMetricAggregations.list([
    ExMetricAggregations.count(
        postCondition: ifCount, shrinker: ExMetricDoubleShrinkers.log(base: 2)),
    ExMetricAggregations.median(postCondition: ExPostConditions.not(ifCount))
  ]);

  final stats = store.aggregateAll(aggregations);
  print(jsonEncode(stats));
}
