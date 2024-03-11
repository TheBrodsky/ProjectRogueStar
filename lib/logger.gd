extends Node


enum LoggingLevel{TRACE, DEBUG, INFO, WARN, ERROR}
const LoggingLevelLabels: Array[String] = ["TRACE","DEBUG", "INFO", "WARN", "ERROR"] # Unfortunate workaround to get enum names, which is not supported natively

const MIN_LEVEL : LoggingLevel = LoggingLevel.DEBUG


func log_trace(message: String) -> void:
	_log(LoggingLevel.TRACE, message)


func log_debug(message: String) -> void:
	_log(LoggingLevel.DEBUG, message)


func log_info(message: String) -> void:
	_log(LoggingLevel.INFO, message)


func log_warn(message: String) -> void:
	_log(LoggingLevel.WARN, message)


func log_error(message: String) -> void:
	_log(LoggingLevel.ERROR, message)


func _log(level : LoggingLevel, message: String) -> void:
	if level >= MIN_LEVEL:
		print(("[%s]: " % LoggingLevelLabels[level]) + message)
