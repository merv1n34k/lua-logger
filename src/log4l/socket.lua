-------------------------------------------------------------------------------
-- Sends the log4l information through a socket using luasocket
--
-- @author Thiago Costa Ponte (thiago@ideais.com.br)
--
-- @copyright 2004-2013 Kepler Project
--
-------------------------------------------------------------------------------

local log4l = require"log4l"
local socket = require"socket"

function log4l.socket(address, port, logPattern, datePattern)
	return log4l.new( function(self, level, message)
		local s = log4l.prepareLogMsg(logPattern, os.date(datePattern), level, message)

		local socket, err = socket.connect(address, port)
		if not socket then
			return nil, err
		end

		local cond, err = socket:send(s)
		if not cond then
			return nil, err
		end
		socket:close()

		return true
	end)
end

return log4l.socket

