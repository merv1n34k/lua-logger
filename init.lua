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

local function indexof(val, t)
	local index = {}
	for k,v in pairs(t) do
		index[v] = k
	end
	return index[val]
end

-------------------------------------------------------------------------------
-- Creates a new logger object
-- @param append Function used by the logger to append a message with a
--	log-level to the log stream.
-- @return Table representing the new logger object.
-------------------------------------------------------------------------------
return function(append, settings)
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
			level = self.levels[order]
		elseif type(level) == "string" then
			order = indexof(level, self.levels)
		end
		if self.level and silent == false then
			self:log("WARN", "Logger: changing loglevel from " .. self.level .. " to " .. level)
		end
		self.level = level
		self.level_order = order
	end
	-- initialize log level.
	logger:setLevel(settings.init.level, settings.init.silent)

	-- generic log function.
	function logger:log(level, msg)
		local order
		if type(level) == "number" then
			order = level
			level = self.levels[order]
		elseif type(level) == "string" then
			order = indexof(level, self.levels)
		end
		if order < self.level_order then
			return
		else
			return self:append(level, msg)
		end
	end

	return logger
end
