local log_email = require"logging.email"

local logger = log_email {
	rcpt = "mail@localhost",
	from = "mail@localhost",
	{
		subject = "[%level] logging.email test",
	}, -- headers
}

assert(logger:info("logging.email test"))
assert(logger:debug("debugging..."))
assert(logger:error("error!"))

print("Mail Logging OK")

