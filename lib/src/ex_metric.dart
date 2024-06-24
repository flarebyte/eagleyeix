import 'dart:convert';

/// Represents a hierarchical metric with a name, dimensions, and value.
///
/// Practical usage:
/// ```dart
/// var metric = ExHierarchicalMetric(
///   name: ['performance', 'api', 'responseTime'],
///   dimensions: {'unit': 'ms', 'language': 'en-gb'},
///   value: 123.45,
/// );
///
/// // Convert to JSON string
/// String jsonString = metric.toJsonString();
///
/// // Convert back from JSON string
/// var newMetric = ExHierarchicalMetric.fromJsonString(jsonString);
/// ```
class ExMetric {
  final List<String> name;
  final Map<String, String> dimensions;
  final double value;

  ExMetric({
    required this.name,
    required this.dimensions,
    required this.value,
  });

  /// Convert an ExHierarchicalMetric instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dimensions': dimensions,
      'value': value,
    };
  }

  /// Create an ExHierarchicalMetric instance from a JSON map.
  factory ExMetric.fromJson(Map<String, dynamic> json) {
    return ExMetric(
      name: List<String>.from(json['name']),
      dimensions: Map<String, String>.from(json['dimensions']),
      value: json['value'],
    );
  }

  /// Convert an ExHierarchicalMetric instance to a JSON string.
  String toJsonString() => jsonEncode(toJson());

  /// Create an ExHierarchicalMetric instance from a JSON string.
  factory ExMetric.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return ExMetric.fromJson(json);
  }

  /// Equality operator override for comparing two ExHierarchicalMetric instances.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExMetric &&
        listEquals(other.name, name) &&
        mapEquals(other.dimensions, dimensions) &&
        other.value == value;
  }

  /// Hash code override for the ExHierarchicalMetric instance.
  @override
  int get hashCode => name.hashCode ^ dimensions.hashCode ^ value.hashCode;
}

/// Helper functions for list equality comparison.
bool listEquals(List? list1, List? list2) {
  if (list1 == null || list2 == null) return list1 == list2;
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

/// Helper functions for map equality comparison.
bool mapEquals(Map? map1, Map? map2) {
  if (map1 == null || map2 == null) return map1 == map2;
  if (map1.length != map2.length) return false;
  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) return false;
  }
  return true;
}

/// Abstract class for predicate to filter metrics.
abstract class ExMetricPredicate {
  bool test(ExMetric metric);
}

/// Represents a collection of hierarchical metrics.
///
/// Practical usage:
/// ```dart
/// var collection = ExHierarchicalMetricCollection();
///
/// var metric1 = ExHierarchicalMetric(
///   name: ['performance', 'api', 'responseTime'],
///   dimensions: {'unit': 'ms', 'language': 'en-gb'},
///   value: 123.45,
/// );
///
/// var metric2 = ExHierarchicalMetric(
///   name: ['performance', 'api', 'throughput'],
///   dimensions: {'unit': 'requests/sec', 'language': 'en-gb'},
///   value: 67.89,
/// );
///
/// // Add metrics to the collection
/// collection.addMetric(metric1);
/// collection.addMetric(metric2);
///
/// // Convert collection to JSON string
/// String jsonString = collection.toJsonString();
///
/// // Convert back from JSON string
/// var newCollection = ExHierarchicalMetricCollection.fromJsonString(jsonString);
/// ```
class ExMetricCollection {
  final Map<String, String> context;
  final List<ExMetric> _metrics = [];

  ExMetricCollection({required this.context});

  /// Adds a metric to the collection.
  void addMetric(ExMetric metric) {
    _metrics.add(metric);
  }

  /// Clears all metrics from the collection.
  void clearMetrics() {
    _metrics.clear();
  }

  get metrics => _metrics;

  /// Clones the current collection.
  ExMetricCollection clone() {
    var clonedCollection = ExMetricCollection(context: context);
    for (var metric in _metrics) {
      clonedCollection.addMetric(metric);
    }
    return clonedCollection;
  }

  /// Filters the collection based on the given predicate.
  ExMetricCollection filter(ExMetricPredicate predicate) {
    var filteredCollection = ExMetricCollection(context: context);
    for (var metric in _metrics) {
      if (predicate.test(metric)) {
        filteredCollection.addMetric(metric);
      }
    }
    return filteredCollection;
  }

  /// Sorts the collection by name, dimensions, then value.
  ExMetricCollection sorted() {
    var sortedMetrics = List<ExMetric>.from(_metrics);
    sortedMetrics.sort((a, b) {
      int compareNames = _compareLists(a.name, b.name);
      if (compareNames != 0) return compareNames;

      int compareDimensions = _compareMaps(a.dimensions, b.dimensions);
      if (compareDimensions != 0) return compareDimensions;

      return a.value.compareTo(b.value);
    });

    var sortedCollection = ExMetricCollection(context: context);
    for (var metric in sortedMetrics) {
      sortedCollection.addMetric(metric);
    }
    return sortedCollection;
  }

  /// Converts the collection to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'context': context,
      'metrics': _metrics.map((metric) => metric.toJson()).toList(),
    };
  }

  /// Creates a collection from a JSON map.
  factory ExMetricCollection.fromJson(Map<String, dynamic> json) {
    final context = Map<String, String>.from(json['context']);
    var collection = ExMetricCollection(context: context);
    if (json['metrics'] != null) {
      json['metrics'].forEach((metricJson) {
        collection.addMetric(ExMetric.fromJson(metricJson));
      });
    }
    return collection;
  }

  /// Converts the collection to a JSON string.
  String toJsonString() => jsonEncode(toJson());

  /// Creates a collection from a JSON string.
  factory ExMetricCollection.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return ExMetricCollection.fromJson(json);
  }

  // Private helper method to compare lists
  int _compareLists(List<String> list1, List<String> list2) {
    int minLength = list1.length < list2.length ? list1.length : list2.length;
    for (int i = 0; i < minLength; i++) {
      int comparison = list1[i].compareTo(list2[i]);
      if (comparison != 0) return comparison;
    }
    return list1.length.compareTo(list2.length);
  }

  // Private helper method to compare maps
  int _compareMaps(Map<String, String> map1, Map<String, String> map2) {
    var keys1 = map1.keys.toList()..sort();
    var keys2 = map2.keys.toList()..sort();

    int compareKeys = _compareLists(keys1, keys2);
    if (compareKeys != 0) return compareKeys;

    for (var key in keys1) {
      int comparison = map1[key]!.compareTo(map2[key]!);
      if (comparison != 0) return comparison;
    }
    return 0;
  }
}
