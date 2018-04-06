local inspect = require('inspect')

local log4l = {}

local DEFAULT_LEVELS = {
	-- The highest possible rank and is intended to turn off logging.
	OFF = "OFF",
	-- Severe errors that cause premature termination. Expect these to be immediately visible on a status console.
	FATAL = "FATAL",
	-- Other runtime errors or unexpected conditions. Expect these to be immediately visible on a status console.
	ERROR = "ERROR",
	-- Use of deprecated APIs, poor use of API, 'almost' errors, other runtime situations that are undesirable or
	-- unexpected, but not necessarily "wrong". Expect these to be immediately visible on a status console.
	WARN = "WARN",
	-- Interesting runtime events (startup/shutdown). Expect these to be immediately visible on a console, so be
	-- conservative and keep to a minimum.
	INFO = "INFO",
	-- Detailed information on the flow through the system. Expect these to be written to logs only. Generally speaking,
	-- most lines logged by your application should be written as DEBUG.
	DEBUG = "DEBUG",
	-- Most detailed information. Expect these to be written to logs only
	TRACE = "TRACE"
}

local MAX_LEVELS = #DEFAULT_LEVELS
-- make level names to order
for i=1,MAX_LEVELS do
	DEFAULT_LEVELS[DEFAULT_LEVELS[i]] = i
end

-- private log function, with support for formating a complex log message.
local function LOG_MSG(self, level, fmt, ...)
	local f_type = type(fmt)
	if f_type == 'string' then
		if select('#', ...) > 0 then
			local status, msg = pcall(string.format, fmt, ...)
			if status then
				return self:append(level, msg)
			else
				return self:append(level, "Error formatting log message: " .. msg)
			end
		else
			-- only a single string, no formating needed.
			return self:append(level, fmt)
		end
	elseif f_type == 'function' then
		-- fmt should be a callable function which returns the message to log
		return self:append(level, fmt(...))
	end
	-- fmt is not a string and not a function, just call inspect() on it.
	return self:append(level, inspect(fmt))
end

-- create the proxy functions for each log level.
local LEVEL_FUNCS = {}
for i=1,MAX_LEVELS do
	local level = DEFAULT_LEVELS[i]
	LEVEL_FUNCS[i] = function(self, ...)
		-- no level checking needed here, this function will only be called if it's level is active.
		return LOG_MSG(self, level, ...)
	end
end

-- do nothing function for disabled levels.
local function disable_level() end

-- improved assertion function.
local function assert(exp, ...)
	-- if exp is true, we are finished so don't do any processing of the parameters
	if exp then return exp, ... end
	-- assertion failed, raise error
	error(string.format(...), 2)
end

-------------------------------------------------------------------------------
-- Creates a new logger object
-- @param append Function used by the logger to append a message with a
--	log-level to the log stream.
-- @return Table representing the new logger object.
-------------------------------------------------------------------------------
function log4l.new(append)
	if type(append) ~= "function" then
		return nil, "Appender must be a function."
	end

	local logger = {}
	logger.append = append

	logger.setLevel = function (self, level)
		local order = DEFAULT_LEVELS[level]
		assert(order, "undefined level `%s'", inspect(level))
		if self.level then
			self:log(log4l.WARN, "Logger: changing loglevel from %s to %s", self.level, level)
		end
		self.level = level
		self.level_order = order
		-- enable/disable levels
		for i=1,MAX_LEVELS do
			local name = DEFAULT_LEVELS[i]:lower()
			if i >= order then
				self[name] = LEVEL_FUNCS[i]
			else
				self[name] = disable_level
			end
		end
	end

	-- generic log function.
	logger.log = function (self, level, ...)
	local order = DEFAULT_LEVELS[level]
	assert(order, "undefined level `%s'", inspect(level))
		if order < self.level_order then
			return
		end
		return LOG_MSG(self, level, ...)
	end

	-- initialize log level.
	logger:setLevel(log4l.DEBUG)
	return logger
end


-------------------------------------------------------------------------------
-- Prepares the log message
-------------------------------------------------------------------------------
function log4l.prepareLogMsg(pattern, dt, level, message)
	local logMsg = pattern or "%date %level %message\n"
	message = string.gsub(message, "%%", "%%%%")
	logMsg = string.gsub(logMsg, "%%date", dt)
	logMsg = string.gsub(logMsg, "%%level", level)
	logMsg = string.gsub(logMsg, "%%message", message)
	return logMsg
end

local luamaj, luamin = _VERSION:match("Lua (%d+)%.(%d+)")
if tonumber(luamaj) == 5 and tonumber(luamin) < 2 then
	-- still create 'log4l' global for Lua versions < 5.2
	_G.log4l = log4l
end

return log4l
