local log_sock = require"logging.socket"

local logger = log_sock("0.0.0.0", 5000)

assert(logger:info("logging.socket test"))
assert(logger:debug("debugging..."))
assert(logger:error("error!"))

print("Socket Logging OK")

