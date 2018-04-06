-------------------------------------------------------------------------------
-- Prints log4l information to console
--
-- @author Thiago Costa Ponte (thiago@ideais.com.br)
--
-- @copyright 2004-2013 Kepler Project
--
-------------------------------------------------------------------------------

local log4l = require"log4l"

function log4l.console(logPattern, datePattern)
	return log4l.new( function(self, level, message)
		io.stdout:write(log4l.prepareLogMsg(logPattern, os.date(datePattern), level, message))
		return true
	end)
end

return log4l.console

