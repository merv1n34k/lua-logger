
local test = {
	"testConsole.lua",
	"testFile.lua",
	"testMail.lua",
	"testSocket.lua",
	"testSQL.lua",
	"testRollingFile.lua",
    "testLibrary.lua",
}

print ("Start of Logging tests")
for _, filename in ipairs(test) do
	dofile("tests/" .. filename)
end
print ("End of Logging tests")

