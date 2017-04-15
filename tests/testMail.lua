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

local bad_logger = log_email {
    rcpt = "mail@5",
    from = "mail@5",
    {
        subject = "[%level] logging.email test",
    }, -- headers
}

assert(not bad_logger:info("logging.email test"))
assert(not bad_logger:debug("debugging..."))
assert(not bad_logger:error("error!"))

assert(not log_email{rcpt = "mail@localhost"})
assert(not log_email{from = "mail@localhost"})

print("Mail Logging OK")

