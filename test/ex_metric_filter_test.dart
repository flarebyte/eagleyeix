import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

void main() {
  group('ExMetricFilters', () {
    final sampleKey =
        ExMetricKey(name: ['test'], dimensions: {'dim1': 'value1'});

    test('ExNotEmptyFilter returns true for non-empty list', () {
      final filter = ExMetricFilters.notEmpty();
      final entry = MapEntry(sampleKey, [1.0, 2.0, 3.0]);
      expect(filter.matches(entry), isTrue);
    });

    test('ExNotEmptyFilter returns false for empty list', () {
      final filter = ExMetricFilters.notEmpty();
      final MapEntry<ExMetricKey, List<double>> entry = MapEntry(sampleKey, []);
      expect(filter.matches(entry), isFalse);
    });

    test('ExMoreThanFilter returns true for list longer than threshold', () {
      final filter = ExMetricFilters.moreThan(2);
      final entry = MapEntry(sampleKey, [1.0, 2.0, 3.0]);
      expect(filter.matches(entry), isTrue);
    });

    test('ExMoreThanFilter returns false for list not longer than threshold',
        () {
      final filter = ExMetricFilters.moreThan(3);
      final entry = MapEntry(sampleKey, [1.0, 2.0, 3.0]);
      expect(filter.matches(entry), isFalse);
    });

    test('ExLessThanFilter returns true for list shorter than threshold', () {
      final filter = ExMetricFilters.lessThan(3);
      final entry = MapEntry(sampleKey, [1.0, 2.0]);
      expect(filter.matches(entry), isTrue);
    });

    test('ExLessThanFilter returns false for list not shorter than threshold',
        () {
      final filter = ExMetricFilters.lessThan(2);
      final entry = MapEntry(sampleKey, [1.0, 2.0]);
      expect(filter.matches(entry), isFalse);
    });

    test(
        'ExMoreThanOrEqualFilter returns true for list longer than or equal to threshold',
        () {
      final filter = ExMetricFilters.moreThanOrEqual(3);
      final entry = MapEntry(sampleKey, [1.0, 2.0, 3.0]);
      expect(filter.matches(entry), isTrue);
    });

    test(
        'ExMoreThanOrEqualFilter returns false for list shorter than threshold',
        () {
      final filter = ExMetricFilters.moreThanOrEqual(4);
      final entry = MapEntry(sampleKey, [1.0, 2.0, 3.0]);
      expect(filter.matches(entry), isFalse);
    });

    test(
        'ExLessThanOrEqualFilter returns true for list shorter than or equal to threshold',
        () {
      final filter = ExMetricFilters.lessThanOrEqual(3);
      final entry = MapEntry(sampleKey, [1.0, 2.0, 3.0]);
      expect(filter.matches(entry), isTrue);
    });

    test('ExLessThanOrEqualFilter returns false for list longer than threshold',
        () {
      final filter = ExMetricFilters.lessThanOrEqual(2);
      final entry = MapEntry(sampleKey, [1.0, 2.0, 3.0]);
      expect(filter.matches(entry), isFalse);
    });
  });

  group('ExMetricKeyValueFilters', () {
    final key = ExMetricKey(
        name: ['metric1'], dimensions: {'region': 'us', 'env': 'prod'});

    test('ExValueEqual matches correctly', () {
      final filter = ExMetricKeyValueFilters.valueEqual(10.0);
      final keyValue = ExMetricKeyValue(key: key, value: 10.0);

      expect(filter.matches(keyValue), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 5.0)), isFalse);
    });

    test('ExValueMoreThan matches correctly', () {
      final filter = ExMetricKeyValueFilters.valueMoreThan(10.0);
      final keyValue = ExMetricKeyValue(key: key, value: 15.0);

      expect(filter.matches(keyValue), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 10.0)), isFalse);
    });

    test('ExValueLessThan matches correctly', () {
      final filter = ExMetricKeyValueFilters.valueLessThan(10.0);
      final keyValue = ExMetricKeyValue(key: key, value: 5.0);

      expect(filter.matches(keyValue), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 10.0)), isFalse);
    });

    test('ExValueMoreThanOrEqual matches correctly', () {
      final filter = ExMetricKeyValueFilters.valueMoreThanOrEqual(10.0);
      final keyValue = ExMetricKeyValue(key: key, value: 10.0);

      expect(filter.matches(keyValue), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 5.0)), isFalse);
    });

    test('ExValueLessThanOrEqual matches correctly', () {
      final filter = ExMetricKeyValueFilters.valueLessThanOrEqual(10.0);
      final keyValue = ExMetricKeyValue(key: key, value: 10.0);

      expect(filter.matches(keyValue), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 15.0)), isFalse);
    });

    test('ExMetricKeyValueOr matches correctly', () {
      final filter = ExMetricKeyValueFilters.or([
        ExMetricKeyValueFilters.valueMoreThan(10.0),
        ExMetricKeyValueFilters.valueEqual(5.0),
      ]);
      final keyValue1 = ExMetricKeyValue(key: key, value: 15.0);
      final keyValue2 = ExMetricKeyValue(key: key, value: 5.0);

      expect(filter.matches(keyValue1), isTrue);
      expect(filter.matches(keyValue2), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 2.0)), isFalse);
    });

    test('ExMetricKeyValueAnd matches correctly', () {
      final filter = ExMetricKeyValueFilters.and([
        ExMetricKeyValueFilters.valueMoreThan(10.0),
        ExMetricKeyValueFilters.valueLessThanOrEqual(20.0),
      ]);
      final keyValue = ExMetricKeyValue(key: key, value: 15.0);

      expect(filter.matches(keyValue), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 25.0)), isFalse);
    });

    test('ExMetricKeyValueNot matches correctly', () {
      final filter =
          ExMetricKeyValueFilters.not(ExMetricKeyValueFilters.valueEqual(10.0));
      final keyValue = ExMetricKeyValue(key: key, value: 5.0);

      expect(filter.matches(keyValue), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 10.0)), isFalse);
    });

    test('ExFilterByAnyDimension matches correctly', () {
      final filter =
          ExMetricKeyValueFilters.filterByAnyDimension(['region', 'zone']);
      final keyValue = ExMetricKeyValue(key: key, value: 10.0);

      expect(filter.matches(keyValue), isTrue);
      expect(
          filter.matches(ExMetricKeyValue(
              key:
                  ExMetricKey(name: ['metric2'], dimensions: {'country': 'us'}),
              value: 10.0)),
          isFalse);
    });

    test('ExMetricKeyValueTrue always matches', () {
      final filter = ExMetricKeyValueFilters.alwaysTrue();
      final keyValue = ExMetricKeyValue(key: key, value: 10.0);

      expect(filter.matches(keyValue), isTrue);
      expect(filter.matches(ExMetricKeyValue(key: key, value: 5.0)), isTrue);
    });
  });
}
