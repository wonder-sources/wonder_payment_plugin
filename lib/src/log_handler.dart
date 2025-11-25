class LogHandler {
  final Function(LogLevel, String) onLogMessage;

  LogHandler(this.onLogMessage);

  void log(LogLevel level, String message) {
    onLogMessage(level, message);
  }
}

enum LogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3);

  const LogLevel(this.value);
  final int value;

  static LogLevel fromValue(int value) {
    return LogLevel.values.firstWhere(
      (element) => element.value == value,
      orElse: () => LogLevel.info,
    );
  }
}
