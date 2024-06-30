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
  static final random = ExMetricKey(name: [
    'eagleyeix',
    'example',
    'random'
  ], dimensions: {
    ExMetricDimUnit.key: ExMetricDimUnit.bytes
  });
  }
void main() {
  var random = Random();

  final store = ExMetricStoreHolder().store;
   for (int _ in Iterable.generate(100)) {
    store.addMetric(AppMetrics.create, 1);
    store.addMetric(AppMetrics.random, random.nextInt(50).toDouble());
  }

  final aggregations = ExMetricAggregations.list([
    ExMetricAggregations.count(shrinker: ExMetricDoubleShrinkers.log(base: 2)),
    ExMetricAggregations.median()
  ]);

  final stats = store.aggregateAll(aggregations);
  print(jsonEncode(stats));
}
