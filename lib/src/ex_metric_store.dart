import 'ex_abstract_model.dart';
import 'ex_metric_key.dart';
import 'ex_metric_key_value.dart';

/// A class representing a store of metrics, using a map of [ExMetricKey] to [double[]].
/// Provides methods for adding metrics and aggregating them.
class ExMetricStore {
  /// The internal map storing the metrics.
  final Map<ExMetricKey, List<double>> _metrics = {};

  /// Adds a metric value to the store by key.
  /// If the key already exists, the value is appended to the existing list.
  void addMetric(ExMetricKey key, double value) {
    if (_metrics.containsKey(key)) {
      _metrics[key]!.add(value);
    } else {
      _metrics[key] = [value];
    }
  }

  /// Returns true if the store is empty.
  bool get isEmpty => _metrics.isEmpty;

  /// Returns true if the store is not empty.
  bool get isNotEmpty => _metrics.isNotEmpty;

  /// Returns the number of unique keys in the store.
  int get length => _metrics.length;

  /// Aggregates all the metrics in the store using the given [ExMetricAggregation] strategy.
  /// Returns a flattened list of [ExMetricKeyValue] instances.
  List<ExMetricKeyValue> aggregateAll(ExMetricAggregation aggregation) {
    List<ExMetricKeyValue> result = [];
    _metrics.forEach((key, values) {
      if (values.isNotEmpty) {
        result.addAll(aggregation.aggregate(MapEntry(key, values)));
      }
    });
    return result;
  }
}

/// A class that holds an instance of `ExMetricStore`.
///
/// The `ExMetricStoreHolder` class provides access to an `ExMetricStore` instance
/// and allows for the creation of a new store.
class ExMetricStoreHolder {
  ExMetricStore _store;

  /// Creates an `ExMetricStoreHolder` with a new instance of `ExMetricStore`.
  ///
  /// This constructor initializes the `_store` field with a new instance of `ExMetricStore`.
  ExMetricStoreHolder() : _store = ExMetricStore();

  /// Gets the current `ExMetricStore` instance.
  ///
  /// Use this property to access the current `ExMetricStore` instance held by this class.
  ExMetricStore get store => _store;

  /// Creates a new `ExMetricStore` instance and overwrites the existing store.
  ///
  /// This method replaces the current `_store` with a new instance of `ExMetricStore`.
  void createNewStore() {
    _store = ExMetricStore();
  }
}
