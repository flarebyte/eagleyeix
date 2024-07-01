/// A class that defines standard logging levels for metrics logging.
class ExMetricDimLevel {
  /// Key name for the logging level.
  static const String key = 'level';

  /// Detailed debug information.
  static const String trace = 'TRACE';

  /// General debugging information.
  static const String debug = 'DEBUG';

  /// Informational messages that highlight the progress of the application.
  static const String info = 'INFO';

  /// Potentially harmful situations.
  static const String warn = 'WARN';

  /// Error events that might still allow the application to continue running.
  static const String error = 'ERROR';

  /// Very severe error events that will presumably lead the application to abort.
  static const String fatal = 'FATAL';
}

/// A class that defines standard units of measurement for metrics in mobile and web applications.
class ExMetricDimUnit {
  /// Key name for an unit.
  static const String key = 'unit';

  /// Time units
  static const String microseconds = 'microseconds';
  static const String milliseconds = 'milliseconds';
  static const String seconds = 'seconds';

  /// Memory units
  static const String bytes = 'bytes';
  static const String kilobytes = 'kilobytes';
  static const String megabytes = 'megabytes';

  /// Percentage units
  static const String percentage = 'percentage';

  /// Data transfer units
  static const String kilobitsPerSecond = 'kilobits-per-second';
  static const String megabitsPerSecond = 'megabits-per-second';

  /// Event count units
  static const String count = 'count';

  /// Frame rate units
  static const String framesPerSecond = 'frames-per-second';
}

/// A class that defines standard HTTP status descriptions for use in metrics logging.
class ExMetricDimStatus {
  static const String key = 'status';
  // Informational responses (100–199)
  static const String continue_ = 'continue';
  static const String switchingProtocols = 'switching-protocols';
  static const String processing = 'processing';

  // Successful responses (200–299)
  static const String ok = 'ok';
  static const String created = 'created';
  static const String accepted = 'accepted';
  static const String nonAuthoritativeInformation =
      'non-authoritative-information';
  static const String noContent = 'no-content';
  static const String resetContent = 'reset-content';
  static const String partialContent = 'partial-content';

  // Redirection messages (300–399)
  static const String multipleChoices = 'multiple-choices';
  static const String movedPermanently = 'moved-permanently';
  static const String found = 'found';
  static const String seeOther = 'see-other';
  static const String notModified = 'not-modified';
  static const String useProxy = 'use-proxy';
  static const String temporaryRedirect = 'temporary-redirect';
  static const String permanentRedirect = 'permanent-redirect';

  // Client error responses (400–499)
  static const String badRequest = 'bad-request';
  static const String unauthorized = 'unauthorized';
  static const String paymentRequired = 'payment-required';
  static const String forbidden = 'forbidden';
  static const String notFound = 'not-found';
  static const String methodNotAllowed = 'method-not-allowed';
  static const String notAcceptable = 'not-acceptable';
  static const String proxyAuthenticationRequired =
      'proxy-authentication-required';
  static const String requestTimeout = 'request-timeout';
  static const String conflict = 'conflict';
  static const String gone = 'gone';
  static const String lengthRequired = 'length-required';
  static const String preconditionFailed = 'precondition-failed';
  static const String payloadTooLarge = 'payload-too-large';
  static const String uriTooLong = 'uri-too-long';
  static const String unsupportedMediaType = 'unsupported-media-type';
  static const String rangeNotSatisfiable = 'range-not-satisfiable';
  static const String expectationFailed = 'expectation-failed';
  static const String misdirectedRequest = 'misdirected-request';
  static const String unprocessableEntity = 'unprocessable-entity';
  static const String locked = 'locked';
  static const String failedDependency = 'failed-dependency';
  static const String tooEarly = 'too-early';
  static const String upgradeRequired = 'upgrade-required';
  static const String preconditionRequired = 'precondition-required';
  static const String tooManyRequests = 'too-many-requests';
  static const String requestHeaderFieldsTooLarge =
      'request-header-fields-too-large';
  static const String unavailableForLegalReasons =
      'unavailable-for-legal-reasons';

  // Server error responses (500–599)
  static const String internalServerError = 'internal-server-error';
  static const String notImplemented = 'not-implemented';
  static const String badGateway = 'bad-gateway';
  static const String serviceUnavailable = 'service-unavailable';
  static const String gatewayTimeout = 'gateway-timeout';
  static const String httpVersionNotSupported = 'http-version-not-supported';
  static const String variantAlsoNegotiates = 'variant-also-negotiates';
  static const String insufficientStorage = 'insufficient-storage';
  static const String loopDetected = 'loop-detected';
  static const String notExtended = 'not-extended';
  static const String networkAuthenticationRequired =
      'network-authentication-required';
}

/// A class that defines standard Dart exceptions for use in metrics logging.
class ExMetricDimDartErr {
  static const String key = 'error';
  // Common Dart exceptions
  static const String formatException = 'format-exception';
  static const String ioException = 'io-exception';
  static const String timeoutException = 'timeout-exception';
  static const String stateError = 'state-error';
  static const String rangeError = 'range-error';
  static const String argumentError = 'argument-error';
  static const String typeError = 'type-error';
  static const String unsupportedError = 'unsupported-error';
  static const String concurrentModificationError =
      'concurrent-modification-error';
  static const String stackOverflowError = 'stack-overflow-error';
  static const String cyclicInitializationError = 'cyclic-initialization-error';
  static const String abstractClassInstantiationError =
      'abstract-class-instantiation-error';
  static const String noSuchMethodError = 'no-such-method-error';
  static const String outOfMemoryError = 'out-of-memory-error';
  static const String unimplementedError = 'unimplemented-error';
  static const String assertionError = 'assertion-error';
  static const String lateInitializationError = 'late-initialization-error';
}

/// A class that defines standard Flutter exceptions for use in metrics logging.
class ExMetricDimFlutterErr {
  static const String key = 'error';
  // Common Flutter exceptions
  static const String flutterError = 'flutter-error';
  static const String missingPluginException = 'missing-plugin-exception';
  static const String asyncSnapshotError = 'async-snapshot-error';
  static const String tickerCanceled = 'ticker-canceled';
  static const String flutterErrorDetails = 'flutter-error-details';
  static const String networkImageLoadException =
      'network-image-load-exception';
  static const String imageCodecException = 'image-codec-exception';
  static const String renderBoxException = 'render-box-exception';
  static const String renderObjectException = 'render-object-exception';
}
