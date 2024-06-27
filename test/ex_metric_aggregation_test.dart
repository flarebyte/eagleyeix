import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

class MockExMetricFilter extends ExMetricFilter {
  @override
  bool matches(MapEntry<ExMetricKey, List<double>> entry) => true;
}

class MockExMetricKeyValueFilter extends ExMetricKeyValueFilter {
  @override
  bool matches(ExMetricKeyValue keyValue) => true;
}

class MockExMetricDoubleShrinker extends ExMetricDoubleShrinker {
  @override
  double shrink(double value) => value;
}

void main() {
  group('ExMetricAggregations', () {
    final preCondition = MockExMetricFilter();
    final postCondition = MockExMetricKeyValueFilter();
    final shrinker = MockExMetricDoubleShrinker();
    final additionalDimensions = {'source': 'test'};

    group('aggregate methods', () {
      final key = ExMetricKey(name: ['metric'], dimensions: {'region': 'us'});

      test('ExMetricSum aggregate', () {
        final exMetricSum = ExMetricAggregations.sum(
          preCondition: preCondition,
          postCondition: postCondition,
          shrinker: shrinker,
          additionalDimensions: additionalDimensions,
        );

        final entry = MapEntry(key, [1.0, 2.0, 3.0]);
        final result = exMetricSum.aggregate(entry);

        expect(result.length, 1);
        expect(result.first.key.name[0], 'metric');
        expect(result.first.key.dimensions['region'], 'us');
        expect(result.first.key.dimensions['source'], 'test');
        expect(result.first.key.dimensions['aggregation'], 'sum');
        expect(result.first.value, 6.0);
      });

      test('ExMetricCount aggregate', () {
        final exMetricCount = ExMetricAggregations.count(
          preCondition: preCondition,
          postCondition: postCondition,
          shrinker: shrinker,
          additionalDimensions: additionalDimensions,
        );

        final entry = MapEntry(key, [1.0, 2.0, 3.0]);
        final result = exMetricCount.aggregate(entry);

        expect(result.length, 1);
        expect(result.first.key.name[0], 'metric');
        expect(result.first.key.dimensions['region'], 'us');
        expect(result.first.key.dimensions['source'], 'test');
        expect(result.first.key.dimensions['aggregation'], 'count');
        expect(result.first.value, 3.0);
      });

      test('ExMetricAvg aggregate', () {
        final exMetricAvg = ExMetricAggregations.average(
          preCondition: preCondition,
          postCondition: postCondition,
          shrinker: shrinker,
          additionalDimensions: additionalDimensions,
        );

        final entry = MapEntry(key, [1.0, 2.0, 3.0]);
        final result = exMetricAvg.aggregate(entry);

        expect(result.length, 1);
        expect(result.first.key.name[0], 'metric');
        expect(result.first.key.dimensions['region'], 'us');
        expect(result.first.key.dimensions['source'], 'test');
        expect(result.first.key.dimensions['aggregation'], 'average');
        expect(result.first.value, 2.0);
      });

      test('ExMetricMedian aggregate', () {
        final exMetricMedian = ExMetricAggregations.median(
          preCondition: preCondition,
          postCondition: postCondition,
          shrinker: shrinker,
          additionalDimensions: additionalDimensions,
        );

        final entry = MapEntry(key, [1.0, 3.0, 2.0]);
        final result = exMetricMedian.aggregate(entry);

        expect(result.length, 1);
        expect(result.first.key.name[0], 'metric');
        expect(result.first.key.dimensions['region'], 'us');
        expect(result.first.key.dimensions['source'], 'test');
        expect(result.first.key.dimensions['aggregation'], 'median');
        expect(result.first.value, 2.0);
      });

      test('ExMetricQuantile aggregate', () {
        final quantile = 0.75;
        final exMetricQuantile = ExMetricAggregations.quantile(
          quantile: quantile,
          preCondition: preCondition,
          postCondition: postCondition,
          shrinker: shrinker,
          additionalDimensions: additionalDimensions,
        );

        final entry =
            MapEntry(key, [3.0, 7.0, 8.0, 2.0, 10.0, 1.0, 5.0, 4.0, 9.0, 6.0]);
        final result = exMetricQuantile.aggregate(entry);

        expect(result.length, 1);
        expect(result.first.key.name[0], 'metric');
        expect(result.first.key.dimensions['region'], 'us');
        expect(result.first.key.dimensions['source'], 'test');
        expect(result.first.key.dimensions['aggregation'], 'quantile');
        expect(result.first.key.dimensions['quantile'], quantile.toString());
        expect(result.first.value, 7.5);
      });
    });
  });
}
