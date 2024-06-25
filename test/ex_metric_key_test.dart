import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

void main() {
  group('ExMetricKeyComparator', () {
    test('compareLists should return 0 for equal lists', () {
      List<String> list1 = ['a', 'b', 'c'];
      List<String> list2 = ['a', 'b', 'c'];
      expect(ExMetricKeyComparator.compareLists(list1, list2), equals(0));
    });

    test('compareLists should return non-zero for different lists', () {
      List<String> list1 = ['a', 'b', 'c'];
      List<String> list2 = ['a', 'b', 'd'];
      expect(ExMetricKeyComparator.compareLists(list1, list2), isNot(0));
    });

    test('compareMaps should return 0 for equal maps', () {
      Map<String, String> map1 = {'key1': 'value1', 'key2': 'value2'};
      Map<String, String> map2 = {'key1': 'value1', 'key2': 'value2'};
      expect(ExMetricKeyComparator.compareMaps(map1, map2), equals(0));
    });

    test('compareMaps should return non-zero for different maps', () {
      Map<String, String> map1 = {'key1': 'value1', 'key2': 'value2'};
      Map<String, String> map2 = {'key1': 'value1', 'key2': 'value3'};
      expect(ExMetricKeyComparator.compareMaps(map1, map2), isNot(0));
    });

    test('listHashCode should return the same hash code for equal lists', () {
      List<String> list1 = ['a', 'b', 'c'];
      List<String> list2 = ['a', 'b', 'c'];
      expect(ExMetricKeyComparator.listHashCode(list1),
          equals(ExMetricKeyComparator.listHashCode(list2)));
    });

    test('mapHashCode should return the same hash code for equal maps', () {
      Map<String, String> map1 = {'key1': 'value1', 'key2': 'value2'};
      Map<String, String> map2 = {'key1': 'value1', 'key2': 'value2'};
      expect(ExMetricKeyComparator.mapHashCode(map1),
          equals(ExMetricKeyComparator.mapHashCode(map2)));
    });
  });

  group('ExMetricKey', () {
    test('compareTo should return 0 for equal ExMetricKey instances', () {
      ExMetricKey key1 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      ExMetricKey key2 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      expect(key1.compareTo(key2), equals(0));
    });

    test('compareTo should return non-zero for different ExMetricKey instances',
        () {
      ExMetricKey key1 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      ExMetricKey key2 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val2'});
      expect(key1.compareTo(key2), isNot(0));
    });

    test('== operator should return true for equal ExMetricKey instances', () {
      ExMetricKey key1 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      ExMetricKey key2 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      expect(key1 == key2, isTrue);
    });

    test('== operator should return false for different ExMetricKey instances',
        () {
      ExMetricKey key1 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      ExMetricKey key2 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val2'});
      expect(key1 == key2, isFalse);
    });

    test('hashCode should be the same for equal ExMetricKey instances', () {
      ExMetricKey key1 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      ExMetricKey key2 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      expect(key1.hashCode, equals(key2.hashCode));
    });

    test('hashCode should be different for different ExMetricKey instances',
        () {
      ExMetricKey key1 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      ExMetricKey key2 =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val2'});
      expect(key1.hashCode, isNot(equals(key2.hashCode)));
    });

    test('toJson should return a valid JSON map', () {
      ExMetricKey key =
          ExMetricKey(name: ['a', 'b'], dimensions: {'dim1': 'val1'});
      expect(
          key.toJson(),
          equals({
            'name': ['a', 'b'],
            'dimensions': {'dim1': 'val1'}
          }));
    });

    test('fromJson should return a valid ExMetricKey instance', () {
      Map<String, dynamic> json = {
        'name': ['a', 'b'],
        'dimensions': {'dim1': 'val1'}
      };
      ExMetricKey key = ExMetricKey.fromJson(json);
      expect(key.name, equals(['a', 'b']));
      expect(key.dimensions, equals({'dim1': 'val1'}));
    });
  });
}
