import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

void main() {
  group('ExMetricLogShrinker', () {
    test('should return the correct logarithmic value plus the start value',
        () {
      final shrinker = ExMetricDoubleShrinkers.log(base: 2, start: 1);
      final result = shrinker.shrink(8);
      expect(result, 4.0);
    });

    test('should throw an error if value is less than or equal to zero', () {
      final shrinker = ExMetricDoubleShrinkers.log(base: 2, start: 1);
      expect(() => shrinker.shrink(0), throwsArgumentError);
      expect(() => shrinker.shrink(-1), throwsArgumentError);
    });

    test('should throw an error if base is less than or equal to one', () {
      expect(() => ExMetricDoubleShrinkers.log(base: 1, start: 1),
          throwsArgumentError);
    });
  });

  group('ExMetricPassShrinker', () {
    test('should return the same value', () {
      final shrinker = ExMetricDoubleShrinkers.pass();
      final result = shrinker.shrink(15);
      expect(result, 15.0);
    });
  });

  group('ExMetricFloorShrinker', () {
    test('should return the floor value plus the start value', () {
      final shrinker = ExMetricDoubleShrinkers.floor(start: 1);
      final result = shrinker.shrink(15.7);
      expect(result, 16.0);
    });
  });

  group('ExMetricCeilShrinker', () {
    test('should return the ceiling value plus the start value', () {
      final shrinker = ExMetricDoubleShrinkers.ceil(start: 1);
      final result = shrinker.shrink(15.3);
      expect(result, 17.0);
    });
  });
}
