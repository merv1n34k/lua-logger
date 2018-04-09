local logger = require"logger"
local socket = require"socket"

function logger.socket(address, port, logPattern, datePattern)
	return logger( function(self, level, message)
		local s = logger.prepareLogMsg(logPattern, os.date(datePattern), level, message)

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

return logger.socket

