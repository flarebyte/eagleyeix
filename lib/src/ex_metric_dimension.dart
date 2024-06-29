/// A class that defines standard logging levels for metrics logging.
class ExMetricDimLevel {
  /// Key name for the logging level.
  static const String level = 'level';

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
