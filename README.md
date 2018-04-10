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

A super basic example of using the logger constructor will be this:

```lua
logger = require('init')
myLogger = logger(function(self, level, message)
  io.stdout:write(level .. "\t" .. message .. "\n")
end)

myLogger:debug('started logging stuff')
myLogger:info('this is just an info message')

myLogger:setLevel('ERROR') -- makes only error / fatal messages appended
myLogger:debug('this debug message should not be printed')
myLogger:info('another unprinted info message')
```
