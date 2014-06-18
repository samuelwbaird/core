local module = require('core.module')

return module(function (module_example)
	
	local some_internal_state = 5
	
	function module_example.some_function(offset)
		some_internal_state = some_internal_state + offset
		return some_internal_state
	end
	
	function module_example.some_other_function()
		return 42
	end
	
end)
