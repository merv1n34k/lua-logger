-------------------------------------------------------------------------------
-- Emails log4l information to the given recipient
--
-- @author Thiago Costa Ponte (thiago@ideais.com.br)
--
-- @copyright 2004-2013 Kepler Project
--
-------------------------------------------------------------------------------

local log4l = require"log4l"
local smtp = require"socket.smtp"

function log4l.email(params)
	params = params or {}
	params.headers = params.headers or {}

	if params.from == nil then
		return nil, "'from' parameter is required"
	end
	if params.rcpt == nil then
		return nil, "'rcpt' parameter is required"
	end

	local datePattern = params.datePattern

	return log4l.new( function(self, level, message)
		local s = log4l.prepareLogMsg(params.logPattern, os.date(datePattern), level, message)
		if params.headers.subject then
			params.headers.subject =
				log4l.prepareLogMsg(params.headers.subject, os.date(datePattern), level, message)
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

return log4l.email

