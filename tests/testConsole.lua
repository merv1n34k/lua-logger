local log_console = require"log4l.console"

local logger = log_console()

assert(logger:info("log4l.console test"))
assert(logger:debug("debugging..."))
assert(logger:error("error!"))
assert(logger:debug("string with %4"))
logger:setLevel("INFO") -- test log level change warning.

print("Console Logging OK")

