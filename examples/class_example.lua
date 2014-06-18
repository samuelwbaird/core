-- include the core classes in the path
package.path = '../core/?.lua:' .. package.path

-- Define MyClass class
local array = require('core.array')
local class = require('core.class')

-- normally a module would return this but we'll just make use of it in this same script
local MyClass = class(function (MyClass)
	-- capture the default constructor
	local super = MyClass.new	

	-- some local stuff private to the class
	print('MyClass is being defined')
	local class_counter = 0

	-- custom constructor
	function MyClass.new()
		local self = super()
		class_counter = class_counter + 1
		self.instance_no = class_counter
		self.collection = array()
		print('instance ' .. class_counter .. ' of MyClass is being instantiated')
		return self
	end
	
	-- method
	function MyClass:collect(obj)
		print('a method is being called on an instance of MyClass')
		self.collection:add(obj)
	end

end)

-- now test out our new class
local test1 = MyClass()
test1:collect({ something_good = true })
local test2 = MyClass()
test2:collect({ something_good = true })
test2:collect({ something_good = true })