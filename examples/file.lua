local logger = require"logger"

local lastFileNameDatePattern
local lastFileHandler

local openFileLogger = function (filename, datePattern)
	local filename = string.format(filename, os.date(datePattern))
	if (lastFileNameDatePattern ~= filename) then
		local f = io.open(filename, "a")
		if (f) then
			f:setvbuf ("line")
			lastFileNameDatePattern = filename
			lastFileHandler = f
			return f
		else
			return nil, string.format("file `%s' could not be opened for writing", filename)
		end
	else
		return lastFileHandler
	end
end

function logger.file(filename, datePattern, logPattern)
	if type(filename) ~= "string" then
		filename = "lualogger.log"
	end

	return logger( function(self, level, message)
		local f, msg = openFileLogger(filename, datePattern)
		if not f then
			return nil, msg
		end
		local s = logger.prepareLogMsg(logPattern, os.date(datePattern), level, message)
		f:write(s)
		return true
	end)
end

return logger.file

