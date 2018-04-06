---------------------------------------------------------------------------
-- RollingFileAppender is a FileAppender that rolls over the logfile
-- once it has reached a certain size limit. It also mantains a
-- maximum number of log files.
--
-- @author Tiago Cesar Katcipis (tiagokatcipis@gmail.com)
--
-- @copyright 2004-2013 Kepler Project
---------------------------------------------------------------------------

local log4l = require"log4l"

local function openFile(self)
	self.file = io.open(self.filename, "a")
	if not self.file then
		return nil, string.format("file `%s' could not be opened for writing", self.filename)
	end
	self.file:setvbuf ("line")
	return self.file
end

local rollOver = function (self)
	for i = self.maxIndex - 1, 1, -1 do
		-- files may not exist yet, lets ignore the possible errors.
		os.rename(self.filename.."."..i, self.filename.."."..i+1)
	end

	self.file:close()
	self.file = nil

	local _, msg = os.rename(self.filename, self.filename..".".."1")

	if msg then
		return nil, string.format("error %s on log rollover", msg)
	end

	return openFile(self)
end


local openRollingFileLogger = function (self)
	if not self.file then
		return openFile(self)
	end

	local filesize = self.file:seek("end", 0)

	if (filesize < self.maxSize) then
		return self.file
	end

	return rollOver(self)
end


function log4l.rolling_file(filename, maxFileSize, maxBackupIndex, logPattern, datePattern)
	if type(filename) ~= "string" then
		filename = "lualog4l.log"
	end

	local obj = {
		filename = filename,
		maxSize  = maxFileSize,
		maxIndex = maxBackupIndex or 1
	}

	return log4l.new( function(self, level, message)
		local f, msg = openRollingFileLogger(obj)
		if not f then
			return nil, msg
		end
		local s = log4l.prepareLogMsg(logPattern, os.date(datePattern), level, message)
		f:write(s)
		return true
	end)
end

return log4l.rolling_file

