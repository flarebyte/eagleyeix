/// A helper class for comparing lists and maps.
/// Contains static methods to facilitate comparisons and hash code calculations.
class ExMetricKeyComparator {
  /// Compares two lists for equality.
  /// Returns 0 if the lists are equal, a negative number if the first list is less, and a positive number if the first list is greater.
  static int compareLists(List<String> a, List<String> b) {
    if (a.length != b.length) return a.length - b.length;
    for (int i = 0; i < a.length; i++) {
      int comparison = a[i].compareTo(b[i]);
      if (comparison != 0) return comparison;
    }
    return 0;
  }

  /// Compares two maps for equality.
  /// Returns 0 if the maps are equal, a negative number if the first map is less, and a positive number if the first map is greater.
  static int compareMaps(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return a.length - b.length;
    for (String key in a.keys) {
      if (!b.containsKey(key)) return -1;
      int comparison = a[key]!.compareTo(b[key]!);
      if (comparison != 0) return comparison;
    }
    return 0;
  }

  /// Computes the hash code for a list.
  static int listHashCode(List<String> list) =>
      list.fold(0, (hash, item) => hash * 31 + item.hashCode);

  /// Computes the hash code for a map.
  static int mapHashCode(Map<String, String> map) => map.entries.fold(0,
      (hash, entry) => hash * 31 + entry.key.hashCode + entry.value.hashCode);
}

/// A class representing a metric key, consisting of a list of names and a map of dimensions.
/// Implements [Comparable] to allow comparison between instances.
/// Instances of this class can be used as keys in a map and can be serialized/deserialized to/from JSON.
class ExMetricKey implements Comparable<ExMetricKey> {
  /// A list of names associated with the metric key.
  final List<String> name;

  /// A map of dimensions associated with the metric key.
  final Map<String, String> dimensions;

  /// Constructs an [ExMetricKey] instance with the given [name] and [dimensions].
  ExMetricKey({
    required this.name,
    required this.dimensions,
  });

  /// Compares this [ExMetricKey] instance with another [ExMetricKey] instance.
  /// Comparison is based on the [name] and [dimensions] fields.
  @override
  int compareTo(ExMetricKey other) {
    int nameComparison = ExMetricKeyComparator.compareLists(name, other.name);
    if (nameComparison != 0) return nameComparison;

    return ExMetricKeyComparator.compareMaps(dimensions, other.dimensions);
  }

  /// Checks if this [ExMetricKey] instance is equal to another object.
  /// Two [ExMetricKey] instances are equal if their [name] and [dimensions] fields are equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExMetricKey &&
          runtimeType == other.runtimeType &&
          ExMetricKeyComparator.compareLists(name, other.name) == 0 &&
          ExMetricKeyComparator.compareMaps(dimensions, other.dimensions) == 0;

  /// Computes the hash code for this [ExMetricKey] instance.
  /// The hash code is based on the [name] and [dimensions] fields.
  @override
  int get hashCode => Object.hash(
        ExMetricKeyComparator.listHashCode(name),
        ExMetricKeyComparator.mapHashCode(dimensions),
      );

  /// Serializes this [ExMetricKey] instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'name': name,
        'dimensions': dimensions,
      };

  /// Deserializes an [ExMetricKey] instance from a JSON object.
  factory ExMetricKey.fromJson(Map<String, dynamic> json) => ExMetricKey(
        name: List<String>.from(json['name']),
        dimensions: Map<String, String>.from(json['dimensions']),
      );
}
