local log_sql = require "log4l.sql"
local has_module, err = pcall(require, "luasql.sqlite3")
if not has_module then
	print("SQLite 3 Logging SKIP (missing luasql.sqlite3)")
else
	local luasql = require "luasql.sqlite3"
	if not luasql or not luasql.sqlite3 then
		print("Missing LuaSQL SQLite 3 driver!")
	else
		local env, err = luasql.sqlite3()

		local logger = log_sql{
			connectionfactory = function()
				local con, err = env:connect("test.db")
				assert(con, err)
				return con
			end,
			keepalive = true,
		}

		assert(logger:info("log4l.sql test"))
		assert(logger:debug("debugging..."))
		assert(logger:error("error!"))

		local reconnecting_logger = log_sql{
			connectionfactory = function()
				local con, err = env:connect("test.db")
				assert(con, err)
				return con
			end,
		}

		assert(reconnecting_logger:info("log4l.sql test"))
		assert(reconnecting_logger:debug("debugging..."))
		assert(reconnecting_logger:error("error!"))

		assert(not log_sql())

		print("SQLite 3 Logging OK")
	end
end

