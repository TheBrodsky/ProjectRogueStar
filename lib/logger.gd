extends Node


enum LoggingLevel{TRACE, DEBUG, INFO, WARN, ERROR}
const LoggingLevelLabels: Array[String] = ["TRACE","DEBUG", "INFO", "WARN", "ERROR"] # Unfortunate workaround to get enum names, which is not supported natively

const MIN_LEVEL: LoggingLevel = LoggingLevel.DEBUG # the minimum level to log
const CALLER_LOG_MIN_LEVEL: LoggingLevel = LoggingLevel.DEBUG # the minimum level where the caller will be logged
var this_path: String


func _enter_tree() -> void:
	this_path = (get_script() as Script).get_path()


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
		var log_string_base: String
		if level >= CALLER_LOG_MIN_LEVEL:
			var caller: Dictionary = _get_caller()
			if caller:
				log_string_base = "[%s] %s//%s: " % [LoggingLevelLabels[level], caller["source"], caller["function"]]
			else:
				log_string_base = "[%s]: " % LoggingLevelLabels[level]
		else:
			log_string_base = "[%s]: " % LoggingLevelLabels[level]
		print(log_string_base + message)


func _get_caller() -> Dictionary:
	var stack: Array = get_stack()
	var return_caller: Dictionary
	for caller: Dictionary in stack:
		if caller["source"] != this_path:
			return_caller = caller
			break
	return return_caller
