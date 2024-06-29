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
