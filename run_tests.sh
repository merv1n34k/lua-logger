#!/bin/sh
#

nc -k -l 5000 & NC_PID=$!
python -m smtpd -n -c DebuggingServer localhost:25 & SMTP_PID=$!

LUA_PATH="src/?.lua;$LUA_PATH" lua -lluacov tests/test.lua
test_exit_code=$?

kill $NC_PID
kill $SMTP_PID

rm -f test.db test.log*
exit "$test_exit_code"
