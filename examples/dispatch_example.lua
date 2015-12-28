-- include the core classes in the path
package.path = '../?.lua;' .. package.path

local dispatch = require('util.dispatch')

-- a weave holds a number of threads
-- it also manages global variables accessible in those threads
local weave = dispatch.weave()
weave.shared_globals.test_message = "I'm testing"

-- add a thread to the weave
local thread = weave:thread(function ()
	while (true) do
		print(test_message)
		coroutine.yield()
	end
end)

-- the thread has some dispatch objects to hook into
thread.on_update:hook(function ()
	print('thread did update')
end)

weave:update()
weave:update()
weave:update()
