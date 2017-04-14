#!/bin/sh
#

LUA_PATH="../src/?.lua;$LUA_PATH" lua -lluacov test.lua
test_exit_code=$?

rm -f test.db test.log*
exit "$test_exit_code"
