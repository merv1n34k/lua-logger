Log4l
=====

Log4l is a fork of [LuaLogging](http://neopallium.github.com/lualogging/) which is a port of Log4j on which it's design was based. The name was changed in the fork from `lualogging` to `log4l` to indicate the differences and to assimilate other ports' names of [Lua4j](https://en.wikipedia.org/wiki/Log4j#Ports) for other languages.

Log4l provides a simple API to use logging features in Lua. Log4l currently supports (out of the box), through the use of appenders, console, file, rolling file, email, socket and sql outputs.

Log4l is free software and uses the same license as Lua.

Installation
============

With LuaRocks:

```
luarocks install log4l
```

Latest Git revision
-------------------

With LuaRocks:

```
luarocks install https://github.com/doronbehar/log4l/raw/master/log4l-scm-0.rockspec
```

Guide lines for improved logging performance
============================================

The changes that I have made allow more complex log message formatting to be done only when 
that log level is enabled.  This will decrease the impact of logging statement when their level 
is disabled.

* Use `string.format()` style formatting:

```lua
logger:info("Some message prefix: val1='%s', val2=%d", "some string value", 1234)
```

* For more complex log message formatting:

```lua
local function log_callback(val1, val2)
	-- Do some complex pre-processing of parameters, maybe dump a table to a string.
	return string.format("Some message prefix: val1='%s', val2=%d", val1, val2)
end
-- function 'log_callback' will only be called if the current log level is "DEBUG"
logger:debug(log_callback, "some string value", 1234)
```
