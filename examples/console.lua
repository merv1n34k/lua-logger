local logger = require"logger"

function logger.console(logPattern, datePattern)
	return logger( function(self, level, message)
		io.stdout:write(logger.prepareLogMsg(logPattern, os.date(datePattern), level, message))
		return true
	end)
end

return logger.console

