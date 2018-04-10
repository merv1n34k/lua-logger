# Lua-logger

## About

Lua-logger is a fork of [LuaLogging](http://neopallium.github.com/lualogging/) which is a port of Log4j upon which it's design was based. The name of the module was changed by [@mwchase](https://github.com/mwchase) in his fork to [`log4l`](https://github.com/mwchase/log4l) to indicate the differences and to assimilate other ports' names of [Lua4j](https://en.wikipedia.org/wiki/Log4j#Ports) for other languages.
I took [@mwchase's version](https://github.com/mwchase/log4l) and made so many changes I decided to publish it under my own domain and calling my luarock `logger`.

This is free software and uses the same license as Lua.

## Installation

With LuaRocks:

```
luarocks install logger
```

## Usage

Basically, when creating a logger object, you need to give the constructor a function called the `appender`. This function, receives `(self, level, message)` is taking care of actually printing the log messages to the console, writing the `message` to a file / SQL database, email it to your INBOX or whatever you want. The `level` parameter is specifying the log level on which the message is supposed to be appended.

### The appender function

A super basic example of using the logger constructor with a simple appender function could be this:

```lua
logger = require('logger')
myLogger = logger(function(self, level, message)
  io.stdout:write(level .. "\t" .. message .. "\n")
end)

myLogger:debug('started logging stuff')
myLogger:info('this is just an info message')

myLogger:setLevel('ERROR') -- makes only error / fatal messages appended
myLogger:debug('this debug message should not be printed')
myLogger:info('another unprinted info message')
```

You can put anything you want in the appender function, you can write to a file, you can use different colors when writing it to the console for different log levels, you can write to different files different messages..

The basic idea though behined the design of every `myLogger:<function>` is to make sure you don't append a message which it's log level

The `self` object, being the first argument to the function, consists of several non-function parameters with these default values.

```lua
{
  level = "DEBUG",
  level_order = 6,
  levels = { "OFF", "FATAL", "ERROR", "WARN", "INFO", "DEBUG", "TRACE" },
}
```

### Configuration

#### Initialization

You can modify several settings when constructing a logger object through the use of a 2nd argument to the `logger` function. Currently, the following settings are read:

```lua
{
  levels = {} -- the different log levels which should be avaiable when creating a logger (usually strings)
  init_level = -- the log level with which the constructor should start (usually a string as well) 
}
```

So for example, in order to use the default `levels` of `{ "OFF", "FATAL", "ERROR", "WARN", "INFO", "DEBUG", "TRACE" }`, but set the initial log level to `"ERROR"` and not `"DEBUG"`, use something like this:

```lua
myLogger = logger(myAppender, {
  init_level = "ERROR"
})
```

If you want to use a different set of `levels` use the constructor in a manner similar to this:

```lua
myLogger = logger(myAppender, {
  levels = { "FATAL", "ERROR", "WARN", "MYSPECIAL_LEVEL", "INFO", "DEBUG"},
  init_level = "WARN"
})
```

For this particular case, the functions `myLogger:fatal()`, `myLogger:error()`, `myLogger:warn()`, `myLogger:myspecial_level()`, `myLogger:debug()` will be created automatically.

**NOTE:** If you intend to use them frequently, then don't put any strings with characters which are not `[a-zA-Z_]` since you'll end up with per level functions which will be called like this:

```lua
myLogger["my-really-spcial-level"]("my really special log message")
```

That's missing the whole point of the per-level functions. In addition, if a log level is not a string, a per level function for it will not be created, for obvious reasons.

#### Changing the log level

If you want to change the current log level, don't use `myLogger.level = "NEW_LEVEL"`, it's not recommended since it doesn't check the requested level is a member of `myLogger.levels` and it doesn't make sure you update `myLogger:setLevel` which receives a number or a member of the `myLogger.levels` array. If it receives a number it should indicate the index of the log level which should be chosen.

## Examples

There are examples under [`examples/`](examples/).
