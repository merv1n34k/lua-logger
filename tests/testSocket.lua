local log_sock = require"log4l.socket"

local logger = log_sock("localhost", 5000)

assert(logger:info("log4l.socket test"))
assert(logger:debug("debugging..."))
assert(logger:error("error!"))

local bad_logger = log_sock("localhost", 5001)

assert(not bad_logger:info("log4l.socket test"))
assert(not bad_logger:debug("debugging..."))
assert(not bad_logger:error("error!"))

print("Socket Logging OK")

