import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

import 'ex_fixtures.dart';

/// A simple aggregation class for testing purposes.
class SumAggregation extends ExMetricAggregation {
  @override
  List<ExMetricKeyValue> aggregate(MapEntry<ExMetricKey, List<double>> entry) {
    double sum = entry.value.reduce((a, b) => a + b);
    return [ExMetricKeyValue(key: entry.key, value: sum)];
  }
}

void main() {
  group('ExMetricStore', () {
    test('addMetric should add a new metric', () {
      ExMetricStore store = ExMetricStore();
      store.addMetric(ExMetricKeyFixtures.buttonClick, 10.0);
      expect(store.isNotEmpty, isTrue);
      expect(store.length, equals(1));
    });

    test('addMetric should append to existing metrics', () {
      ExMetricStore store = ExMetricStore();
      store.addMetric(ExMetricKeyFixtures.buttonClick, 10.0);
      store.addMetric(ExMetricKeyFixtures.buttonClick, 20.0);
      expect(store.length, equals(1));
      expect(store.aggregateAll(SumAggregation()).first.value, equals(30.0));
    });

    test('isEmpty should return true for empty store', () {
      ExMetricStore store = ExMetricStore();
      expect(store.isEmpty, isTrue);
    });

    test('isNotEmpty should return true for non-empty store', () {
      ExMetricStore store = ExMetricStore();
      store.addMetric(ExMetricKeyFixtures.buttonClick, 10.0);
      expect(store.isNotEmpty, isTrue);
    });

    test('length should return correct number of unique keys', () {
      ExMetricStore store = ExMetricStore();
      store.addMetric(ExMetricKeyFixtures.buttonClick, 10.0);
      store.addMetric(ExMetricKeyFixtures.screenView, 20.0);
      expect(store.length, equals(2));
    });

    test('aggregateAll should return aggregated values', () {
      ExMetricStore store = ExMetricStore();
      store.addMetric(ExMetricKeyFixtures.buttonClick, 10.0);
      store.addMetric(ExMetricKeyFixtures.buttonClick, 20.0);
      store.addMetric(ExMetricKeyFixtures.screenView, 5.0);
      store.addMetric(ExMetricKeyFixtures.screenView, 15.0);

      List<ExMetricKeyValue> aggregated = store.aggregateAll(SumAggregation());
      expect(aggregated.length, equals(2));
      expect(
          aggregated
              .firstWhere((kv) => kv.key == ExMetricKeyFixtures.buttonClick)
              .value,
          equals(30.0));
      expect(
          aggregated
              .firstWhere((kv) => kv.key == ExMetricKeyFixtures.screenView)
              .value,
          equals(20.0));
    });
  });
}
