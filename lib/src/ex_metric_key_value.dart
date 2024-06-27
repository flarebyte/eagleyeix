import 'ex_metric_key.dart';

/// A class representing a metric key-value pair, consisting of an [ExMetricKey] and a double value.
/// Provides methods for comparing instances and serializing to JSON.
class ExMetricKeyValue implements Comparable<ExMetricKeyValue> {
  /// The key of the metric, of type [ExMetricKey].
  final ExMetricKey key;

  /// The value of the metric, of type double.
  final double value;

  /// Constructs an [ExMetricKeyValue] instance with the given [key] and [value].
  ExMetricKeyValue({
    required this.key,
    required this.value,
  });

  /// Compares this [ExMetricKeyValue] instance with another [ExMetricKeyValue] instance.
  /// Comparison is based on the [key] and then the [value].
  @override
  int compareTo(ExMetricKeyValue other) {
    int keyComparison = key.compareTo(other.key);
    if (keyComparison != 0) return keyComparison;

    return value.compareTo(other.value);
  }

  /// Serializes this [ExMetricKeyValue] instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'key': key.toJson(),
        'value': value,
      };

  /// Deserializes an [ExMetricKeyValue] instance from a JSON object.
  factory ExMetricKeyValue.fromJson(Map<String, dynamic> json) =>
      ExMetricKeyValue(
        key: ExMetricKey.fromJson(json['key']),
        value: json['value'],
      );

  /// Checks if this [ExMetricKeyValue] instance is equal to another object.
  /// Two [ExMetricKeyValue] instances are equal if their [key] and [value] fields are equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExMetricKeyValue &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  /// Computes the hash code for this [ExMetricKeyValue] instance.
  /// The hash code is based on the [key] and [value] fields.
  @override
  int get hashCode => Object.hash(key, value);
}
