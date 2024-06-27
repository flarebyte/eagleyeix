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
}
