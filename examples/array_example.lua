-- include the core classes in the path
package.path = '../core/?.lua:' .. package.path

-- require the array module
local array = require('core.array')

-- create some arrays and do something witht them
local collection1 = array()
local collection2 = array()

collection1:push(1)
collection1:push(2)
collection1:push(3)
collection1:push(4)
print(collection1)

collection2:push(5)
collection2:push(4)
collection2:push(3)
print(collection2)

collection1:with_each(function (c1)
	collection2:with_each(function (c2)
		print(c1 .. ':' .. c2)
	end)
end)
