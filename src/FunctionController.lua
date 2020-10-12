
local TEMPLATE = script.Parent:WaitForChild("TEMPLATE"):WaitForChild("MAIN"):WaitForChild("FunctionController")

-- Provides a GUI interface to fire a specified method, a property of an object.
-- @TODO: Disabled
function FunctionController(gui, object, property, text)
	
	local frame = TEMPLATE:Clone()
	frame.Parent = gui.content
	
	local onClickEvent 	= frame:WaitForChild("OnClick")
	local labelValue 	= frame:WaitForChild("Label")	
	
	-- The function to be called on change.
	local onChange
	
	local controller = {
		frame = frame,
		label = frame:WaitForChild("LabelText"),
		height = frame.AbsoluteSize.Y
	}
	
	------------------------------------------------------------------
	-- Configure events
	------------------------------------------------------------------
	onClickEvent.Event:connect(function()	
		if not controller._isReadonly then
			if onChange ~= nil then
				onChange();
			end
			controller.getValue()(object)
		end
	end)
	
	------------------------------------------------------------------
	-- Public functions
	------------------------------------------------------------------
	
	function controller.onChange(fnc)
		onChange = fnc;
		return controller;
	end	
	
	function controller.setValue(value)
		if not controller._isReadonly then
			object[property] = value
		end
		
		return controller;
	end
	
	function controller.getValue()		
		return object[property]
	end
	
	-- Removes the controller from its parent GUI.
	function controller.remove()
		
		gui.removeChild(controller)
		
		if controller.frame ~= nil then
			controller.frame.Parent = nil
			controller.frame = nil
		end		
		
		controller = nil
	end
	
	-- Sets the name of the controller.
	function controller.name(name)
		labelValue.Value = name
		return controller
	end
	
	------------------------------------------------------------------
	-- Set initial values
	------------------------------------------------------------------
	
	if text == nil or string.len(text) == 0 then
		labelValue.Value = property	
	else
		labelValue.Value = text	
	end
	
	return controller
end

return FunctionController
