local logger = require"logger"
local smtp = require"socket.smtp"

function logger.email(params)
	params = params or {}
	params.headers = params.headers or {}

	if params.from == nil then
		return nil, "'from' parameter is required"
	end
	if params.rcpt == nil then
		return nil, "'rcpt' parameter is required"
	end

	local datePattern = params.datePattern

	return logger( function(self, level, message)
		local s = logger.prepareLogMsg(params.logPattern, os.date(datePattern), level, message)
		if params.headers.subject then
			params.headers.subject =
				logger.prepareLogMsg(params.headers.subject, os.date(datePattern), level, message)
		end
		local msg = { headers = params.headers, body = s }
		params.source = smtp.message(msg)

		local r, e = smtp.send(params)
		if not r then
			return nil, e
		end

		return true
	end)
end

return logger.email

