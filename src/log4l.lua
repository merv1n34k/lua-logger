local inspect = require('inspect')

local log4l = {}

local DEFAULT_LEVELS = {
	-- The highest possible rank and is intended to turn off logging.
	"OFF",
	-- Severe errors that cause premature termination. Expect these to be immediately visible on a status console.
	"FATAL",
	-- Other runtime errors or unexpected conditions. Expect these to be immediately visible on a status console.
	"ERROR",
	-- Use of deprecated APIs, poor use of API, 'almost' errors, other runtime situations that are undesirable or
	-- unexpected, but not necessarily "wrong". Expect these to be immediately visible on a status console.
	"WARN",
	-- Interesting runtime events (startup/shutdown). Expect these to be immediately visible on a console, so be
	-- conservative and keep to a minimum.
	"INFO",
	-- Detailed information on the flow through the system. Expect these to be written to logs only. Generally speaking,
	-- most lines logged by your application should be written as DEBUG.
	"DEBUG",
	-- Most detailed information. Expect these to be written to logs only
	"TRACE"
}

-- private log function, with support for formating a complex log message.
local function log_msg(self, level, fmt, ...)
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
function log4l.new(append, settings)
	if type(append) ~= "function" then
		return nil, "Appender must be a function."
	end

	local logger = {}
	logger.append = append

	-- initialize all default values
	if not settings then
		settings = {}
	end
	setmetatable(settings, {
		__index = {
			levels = DEFAULT_LEVELS,
			init = {
				level = DEFAULT_LEVELS[6],
				silent = false
			}
		}
	})
	logger.levels = settings.levels

	function logger:setLevel(level, silent)
		local order
		if type(level) == "number" then
			order = level
			level = logger.levels[order]
		elseif type(level) == "string" then
			local index = {}
			for k,v in pairs(logger.levels) do
				index[v] = k
			end
			order = index[level]
		end
		assert(order, "undefined level `%s'", inspect(level))
		if self.level and silent == false then
			self:log("WARN", "Logger: changing loglevel from %s to %s", self.level, level)
		end
		self.level = level
		self.level_order = order
		-- enable/disable levels
		for i = 1,#logger.levels do
			local name = self.levels[i]:lower()
			if i >= order then
				self[name] = function(...)
					-- no level checking needed here, this function will only be called
					-- if it's level is active.
					return log_msg(self, self.level, ...)
				end
			else
				self[name] = function () return end
			end
		end
	end
	-- initialize log level.
	logger:setLevel(settings.init.level, settings.init.silent)

	-- generic log function.
	function logger:log(level, ...)
		local order
		if type(level) == "number" then
			order = level
			level = logger.levels[order]
		elseif type(level) == "string" then
			local index = {}
			for k,v in pairs(logger.levels) do
				index[v] = k
			end
			order = index[level]
		end
		assert(order, "undefined level `%s'", inspect(level))
		if order < self.level_order then
			return
		end
		return log_msg(self, level, ...)
	end


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
