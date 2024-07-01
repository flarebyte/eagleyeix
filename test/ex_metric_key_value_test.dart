import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

import 'ex_fixtures.dart';

void main() {
  group('ExMetricKeyValue', () {
    test('compareTo should return 0 for equal ExMetricKeyValue instances', () {
      ExMetricKeyValue keyValue1 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      ExMetricKeyValue keyValue2 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      expect(keyValue1.compareTo(keyValue2), equals(0));
    });

    test(
        'compareTo should return non-zero for different ExMetricKeyValue instances',
        () {
      ExMetricKeyValue keyValue1 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      ExMetricKeyValue keyValue2 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 20.0,
      );
      expect(keyValue1.compareTo(keyValue2), isNot(0));
    });

    test('compareTo should prioritize key comparison over value comparison',
        () {
      ExMetricKeyValue keyValue1 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      ExMetricKeyValue keyValue2 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.screenView,
        value: 10.0,
      );
      expect(keyValue1.compareTo(keyValue2), isNot(0));
    });

    test('== operator should return true for equal ExMetricKeyValue instances',
        () {
      ExMetricKeyValue keyValue1 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      ExMetricKeyValue keyValue2 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      expect(keyValue1 == keyValue2, isTrue);
    });

    test(
        '== operator should return false for different ExMetricKeyValue instances',
        () {
      ExMetricKeyValue keyValue1 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      ExMetricKeyValue keyValue2 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.screenView,
        value: 10.0,
      );
      expect(keyValue1 == keyValue2, isFalse);
    });

    test('hashCode should be the same for equal ExMetricKeyValue instances',
        () {
      ExMetricKeyValue keyValue1 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      ExMetricKeyValue keyValue2 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      expect(keyValue1.hashCode, equals(keyValue2.hashCode));
    });

    test(
        'hashCode should be different for different ExMetricKeyValue instances',
        () {
      ExMetricKeyValue keyValue1 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      ExMetricKeyValue keyValue2 = ExMetricKeyValue(
        key: ExMetricKeyFixtures.screenView,
        value: 10.0,
      );
      expect(keyValue1.hashCode, isNot(equals(keyValue2.hashCode)));
    });

    test('toJson should return a valid JSON map', () {
      ExMetricKeyValue keyValue = ExMetricKeyValue(
        key: ExMetricKeyFixtures.buttonClick,
        value: 10.0,
      );
      expect(
        keyValue.toJson(),
        equals({
          'key': {
            'name': ['interaction', 'button_click'],
            'dimensions': {'button_id': 'add_to_cart', 'screen': 'product_page'}
          },
          'value': 10.0
        }),
      );
    });

    test('fromJson should return a valid ExMetricKeyValue instance', () {
      Map<String, dynamic> json = {
        'key': {
          'name': ['interaction', 'button_click'],
          'dimensions': {'button_id': 'add_to_cart', 'screen': 'product_page'}
        },
        'value': 10.0
      };
      ExMetricKeyValue keyValue = ExMetricKeyValue.fromJson(json);
      expect(keyValue.key, equals(ExMetricKeyFixtures.buttonClick));
      expect(keyValue.value, equals(10.0));
    });
  });
}
