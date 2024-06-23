import 'package:eagleyeix/metric.dart';
import 'package:test/test.dart';

void main() {
  group('ExHierarchicalMetric Tests', () {
    test('Serialization and Deserialization', () {
      var metric = ExHierarchicalMetric(
        name: ['performance', 'api', 'responseTime'],
        dimensions: {'unit': 'ms', 'language': 'en-gb'},
        value: 123.45,
      );

      // Convert to JSON string
      String jsonString = metric.toJsonString();

      // Convert back from JSON string
      var newMetric = ExHierarchicalMetric.fromJsonString(jsonString);

      expect(newMetric, equals(metric));
    });

    test('Equality Check', () {
      var metric1 = ExHierarchicalMetric(
        name: ['performance', 'api', 'responseTime'],
        dimensions: {'unit': 'ms', 'language': 'en-gb'},
        value: 123.45,
      );

      var metric2 = ExHierarchicalMetric(
        name: ['performance', 'api', 'responseTime'],
        dimensions: {'unit': 'ms', 'language': 'en-gb'},
        value: 123.45,
      );

      expect(metric1, equals(metric2));
    });
  });

  group('ExHierarchicalMetricCollection Tests', () {
    var context = {'device': 'mobile', 'version': '1.0.1'};
    test('Add and Clear Metrics', () {
      var collection = ExHierarchicalMetricCollection(context: context);

      var metric1 = ExHierarchicalMetric(
        name: ['performance', 'api', 'responseTime'],
        dimensions: {'unit': 'ms', 'language': 'en-gb'},
        value: 123.45,
      );

      var metric2 = ExHierarchicalMetric(
        name: ['performance', 'api', 'throughput'],
        dimensions: {'unit': 'requests/sec', 'language': 'en-gb'},
        value: 67.89,
      );

      collection.addMetric(metric1);
      collection.addMetric(metric2);

      expect(collection.toJson()['metrics'].length, equals(2));

      collection.clearMetrics();
      expect(collection.toJson()['metrics'].length, equals(0));
    });

    test('Clone Collection', () {
      var collection = ExHierarchicalMetricCollection(context: context);

      var metric1 = ExHierarchicalMetric(
        name: ['performance', 'api', 'responseTime'],
        dimensions: {'unit': 'ms', 'language': 'en-gb'},
        value: 123.45,
      );

      collection.addMetric(metric1);
      var clonedCollection = collection.clone();

      expect(
          clonedCollection.toJsonString(), equals(collection.toJsonString()));
    });

    test('Filter Collection', () {
      var collection = ExHierarchicalMetricCollection(context: context);

      var metric1 = ExHierarchicalMetric(
        name: ['performance', 'api', 'responseTime'],
        dimensions: {'unit': 'ms', 'language': 'en-gb'},
        value: 123.45,
      );

      var metric2 = ExHierarchicalMetric(
        name: ['performance', 'api', 'throughput'],
        dimensions: {'unit': 'requests/sec', 'language': 'en-gb'},
        value: 67.89,
      );

      collection.addMetric(metric1);
      collection.addMetric(metric2);

      var predicate = _ValuePredicate(100.0);
      var filteredCollection = collection.filter(predicate);

      expect(filteredCollection.toJson()['metrics'].length, equals(1));
      expect(
          filteredCollection.toJson()['metrics'][0]['value'], equals(123.45));
    });

    test('Sort Collection', () {
      var collection = ExHierarchicalMetricCollection(context: context);

      var metric1 = ExHierarchicalMetric(
        name: ['performance', 'api', 'responseTime'],
        dimensions: {'unit': 'ms', 'language': 'en-gb'},
        value: 123.45,
      );

      var metric2 = ExHierarchicalMetric(
        name: ['performance', 'api', 'throughput'],
        dimensions: {'unit': 'requests/sec', 'language': 'en-gb'},
        value: 67.89,
      );

      collection.addMetric(metric2);
      collection.addMetric(metric1);

      var sortedCollection = collection.sorted();

      expect(sortedCollection.toJson()['metrics'][0]['name'][2],
          equals('responseTime'));
      expect(sortedCollection.toJson()['metrics'][1]['name'][2],
          equals('throughput'));
    });

    test('Serialization and Deserialization', () {
      var collection = ExHierarchicalMetricCollection(context: context);

      var metric1 = ExHierarchicalMetric(
        name: ['performance', 'api', 'responseTime'],
        dimensions: {'unit': 'ms', 'language': 'en-gb'},
        value: 123.45,
      );

      var metric2 = ExHierarchicalMetric(
        name: ['performance', 'api', 'throughput'],
        dimensions: {'unit': 'requests/sec', 'language': 'en-gb'},
        value: 67.89,
      );

      collection.addMetric(metric2);
      collection.addMetric(metric1);
      // Convert to JSON string
      String jsonString = collection.toJsonString();

      // Convert back from JSON string
      var newCollection = ExHierarchicalMetricCollection.fromJsonString(jsonString);

      expect(newCollection.context, equals(collection.context));
      expect(newCollection.metrics, equals(collection.metrics));
    });
  });


}

/// Example predicate for filtering by value.
class _ValuePredicate implements ExMetricPredicate {
  final double minValue;

  _ValuePredicate(this.minValue);

  @override
  bool test(ExHierarchicalMetric metric) {
    return metric.value > minValue;
  }
}
