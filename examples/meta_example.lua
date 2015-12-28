-- include the core classes in the path
package.path = '../?.lua;' .. package.path

local meta = require('core.meta')
local class = require('core.class')
local array = require('core.array')


-- test some code that _should_ fail
local function test_failure(thunk)
	local result, error = pcall(thunk)
	if result then
		print('this should not be possible')
	else
		print('got error ' .. error)
	end
	
end

-- a little class to help demonstrate some other features
local little_class = class(function (little_class)
	-- reads from unknown values are errors
	little_class:strict()
	-- writes to unknown values are errors
	little_class:seal()

	local counter = 0

	function little_class:init()
		print('a little class object was instantiated')
		counter = counter + 1
		-- writes are sealed, so rawset to set values
		rawset(self, 'identity', counter)
	end

	function little_class:identify_yourself()
		print('little object ' .. self.identity)
	end	
	
	-- add a read only property
	little_class:add_property('full_identity', function (self)
		return 'little:' .. self.identity
	end)
end)

-- create a class with lazy and dynamic properties
local test_class = class(function (test_class)
	-- reads from unknown values are errors
	test_class:strict()

	function test_class:init(name)
		self.name = name
	end
	
	-- lazy properties
	test_class:add_lazy_property('little', little_class)
end)


-- modify an existing metatable to insert a new handler
print('\n:testing intercepted metatable')
local init_count = 0
meta.intercept_index(test_class, function (obj, property, default)
	if property == 'init' then
		-- replace this with a richer function
		return true, function (...)
			-- before the function
			print('about to call test class init')
			-- invoke the normal function
			default(obj, property) (...)
			-- after the function
			init_count = init_count + 1
			print('test class init called ' .. init_count .. ' times')
		end
	end
end)

-- create some test objects to use
local test1 = test_class('test object 1')
local test2 = test_class('test object 2')

print('\n:testing lazy properties')
test1.little:identify_yourself()
test2.little:identify_yourself()
test1.little:identify_yourself()
test2.little:identify_yourself()
print(test1.little.full_identity)
print(test2.little.full_identity)
test_failure(function ()
	-- should not be able to assign a readonly property
	test1.little.full_identity = 'the wrong thing'
end)

print('\n:test sealed and strict')
test_failure(function ()
	-- should not be able to set new value on sealed little object
	test1.little.new_prop = 'new value'
end)
test_failure(function ()
	-- should not be able to read unknown property on strict object
	print(test1.mistyped_property)
end)

-- create readonly proxies of some of those objects
print('\n:testing readonly proxy')
local test1_ro = meta.readonly(test1)

-- can read all the normal fields off the proxy
print(test1_ro.name)
test1_ro.little:identify_yourself()

-- but cannot set existing or new fields on the proxy
test_failure(function ()
	test1_ro.name = 'new name'
end)
