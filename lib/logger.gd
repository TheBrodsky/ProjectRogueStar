extends Node


enum LoggingLevel{TRACE, DEBUG, INFO, WARN, ERROR}
const LoggingLevelLabels = ["TRACE","DEBUG", "INFO", "WARN", "ERROR"] # Unfortunate workaround to get enum names, which is not supported natively

const MIN_LEVEL : LoggingLevel = LoggingLevel.DEBUG


func log_trace(message: String):
	_log(LoggingLevel.TRACE, message)


func log_debug(message: String):
	_log(LoggingLevel.DEBUG, message)


func log_info(message: String):
	_log(LoggingLevel.INFO, message)


func log_warn(message: String):
	_log(LoggingLevel.WARN, message)


func log_error(message: String):
	_log(LoggingLevel.ERROR, message)


func _log(level : LoggingLevel, message: String):
	if level >= MIN_LEVEL:
		print(("[%s]: " % LoggingLevelLabels[level]) + message)
