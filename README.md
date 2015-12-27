# core _Lua modules_

It is in both the spirit and nature of Lua that every Lua programmer will at some reasonably early point implement their own class system and a variety of other base structures. These are mine.

## notes

Most of these Lua modules use the class module. The structure of the class module was designed to make creating a class consistent and slightly more declarative. Class instances are implemented with the typical metatable pattern and are reasonably lightweight, not attempting to emulate an inheritance and encapsulation model from another language. The class function is called with a function that constructs the class, the result of which is typically returned as a Lua module.

	-- myclass.lua
	local array = require('core.array')
	local class = require('core.class')

	-- this module defines a class
	return class(function (myclass)

		-- custom constructor
		function myclass:init(name)
			self.name = name
			self.collection = array()
		end
	
		-- method
		function myclass:collect(obj)
			self.collection:add(obj)
		end

	end)

A class can be instantiated by calling classname.new() or with the __call metamethod eg. classname()

	-- test.lua
	local myclass = require('myclass')
	local instance = myclass("good things collection")
	instance:collect({ something_good = true })

The module template is a simplified version of the same structure without the extra layer of metatables. A module is instantiated once by default as part of the Lua require process, but the __call metamethod can be used to create multiple instantians of a module if required.

	-- module_example.lua
	local module = require('core.module')

	return module(function (module_example)
		function module_example.some_function()
			return 42
		end
	end)
	
	-- test.lua
	local module_example = require('module_example')
	module_example.some_function()


## installation

Make sure the core folder is available in the LUA_PATH
	
## documentation

I have a range of libraries covering lists, pools, queues, caches, and event dispatch to add. I hope to include some basic documentation and example usage for each module. This documentation is not yet ready and most of the modules require some clean up around consistency and commenting, additional code will make it in to the repository as I'm able to address this.
 
