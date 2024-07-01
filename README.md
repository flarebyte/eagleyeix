# eagleyeix

![Experimental](https://img.shields.io/badge/status-experimental-blue)

> Eagleyeix the Dart library for sharper observations and smarter
> reactions

Eagleyeix is a metrics logger that collects and records numerical data
representing system performance or application behaviour, typically in
key-value pairs. Unlike general loggers, it focuses solely on metrics such as
CPU usage, memory consumption, request rates, and business KPIs.

![Hero image for eagleyeix](doc/eagleyeix.jpeg)

Highlights:

-   Collect numerical data representing system performance or application
    behaviour.
-   Ensure higher user privacy by aggregating the data. Aggregation
    involves combining individual data points into broader summaries.
-   To improve privacy, metric data can be stored as orders of magnitude.
-   Metrics data can be exported as JSON

A few examples:

Create a metric key:

```dart
static final create = ExMetricKey(name: ['eagleyeix','example','create'],
dimensions: {'unit': 'count'});
```

Create a metric store:

```dart
final store = ExMetricStoreHolder().store;
```

Add a metric:

```dart
store.addMetric(create, 0.7);
```

Create a median aggregation:

```dart
final median = ExMetricAggregations.median()
```

Aggregate the metrics:

```dart
store.aggregateAll(median);
```

## Documentation and links

-   [Code Maintenance :wrench:](MAINTENANCE.md)
-   [Code Of Conduct](CODE_OF_CONDUCT.md)
-   [Contributing :busts\_in\_silhouette: :construction:](CONTRIBUTING.md)
-   [Architectural Decision Records :memo:](DECISIONS.md)
-   [Contributors
    :busts\_in\_silhouette:](https://github.com/flarebyte/eagleyeix/graphs/contributors)
-   [Dependencies](https://github.com/flarebyte/eagleyeix/network/dependencies)
-   [Glossary
    :book:](https://github.com/flarebyte/overview/blob/main/GLOSSARY.md)
-   [Software engineering principles
    :gem:](https://github.com/flarebyte/overview/blob/main/PRINCIPLES.md)
-   [Overview of Flarebyte.com ecosystem
    :factory:](https://github.com/flarebyte/overview)
-   [Dart dependencies](DEPENDENCIES.md)
-   [Usage](USAGE.md)
-   [Example](example/example.dart)

## Related

-   [anonymous-graph-stats](https://github.com/flarebyte/anonymous-graph-stats)
